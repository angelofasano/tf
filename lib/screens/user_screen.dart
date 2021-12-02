import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tf/bloc/user_bloc.dart';
import 'package:tf/components/addressCard.dart';
import 'package:tf/components/header.dart';
import 'package:tf/components/horizontalList.dart';
import 'package:tf/components/orderCard.dart';
import 'package:tf/redux/actions/deleteUserAccessTokenAction.dart';
import 'package:tf/redux/appState.dart';
import 'package:tf/repositories/user_repository.dart';
import 'package:tf/screens/address_create_screen.dart';
import 'package:tf/screens/user_update_screen.dart';
import 'package:tf/utils/addressCreateArguments.dart';
import 'package:tf/utils/apiResponse.dart';
import 'package:tf/utils/userUpdateArguments.dart';

class UserScreen extends StatefulWidget {
  static String routeName = '/user';
  final Function reloadPage;

  UserScreen({required this.reloadPage});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String? phoneNumber;
  late UserBloc _bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        onInit: (store) => {_bloc = UserBloc(store.state.userAccessToken)},
        builder: (_, store) => Scaffold(
              body: StreamBuilder<ApiResponse<UserResponse>>(
                stream: _bloc.userStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.LOADING:
                        return const Center(child: CircularProgressIndicator());
                      case Status.COMPLETED:
                        return _onComplete(snapshot.data!.data!, store);
                      case Status.ERROR:
                        return Center(child: Text(snapshot.data!.message!));
                      default:
                        return Center(child: Text(''));
                    }
                  }
                  return Container();
                },
              ),
            ));
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  dynamic _onComplete(UserResponse user, store) {
    return Scaffold(
        appBar: AppBar(
          title: Text(user.displayName),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle(title: 'Informazioni generali'),
                    InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            UserUpdateScreen.routeName,
                            arguments: UserUpdateArguments(
                                store.state.userAccessToken,
                                () => {widget.reloadPage(store.state.userAccessToken)},
                                user.acceptsMarketing,
                                user.email,
                                user.phone),
                          );
                        },
                        child: Card(
                            child: Padding(
                                padding: EdgeInsets.only(
                                    right: 25, left: 25, top: 15, bottom: 15),
                                child: Column(children: [
                                  _sectionLabelSpacer(),
                                  _sectionLabel(['Marketing', user.acceptsMarketing ? 'Si' : 'No']),
                                  _sectionLabelSpacer(),
                                  _sectionLabel(['Email', user.email]),
                                  _sectionLabelSpacer(),
                                  _sectionLabel(['Telefono', user.phone]),
                                  _sectionLabelSpacer(),
                                ])))),
                    _sectionTitle(
                        title: 'I tuoi indirizzi',
                        iconbutton: IconButton(
                          icon: Icon(Icons.post_add_outlined,
                              color: Theme.of(context).primaryColor),
                          tooltip: 'Aggiungi',
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AddressCreateScreen.routeName,
                              arguments: AddressCreateArguments(
                                  store.state.userAccessToken,
                                  () => {widget.reloadPage(store.state.userAccessToken)},
                            ));
                          },
                        )),
                    user.addresses.isEmpty
                        ? EmptyCard(title: 'Non ci sono indirizzi')
                        : HorizontalList(
                            elements: user.addresses
                                .map((addr) => AddressCard(
                                      address: addr,
                                      isDefault:
                                          addr.id == user.defaultAddress.id,
                                      token: store.state.userAccessToken,
                                      successCallback: () => {widget.reloadPage(store.state.userAccessToken)},
                                    ))
                                .toList()),
                    _sectionTitle(title: 'Ultimi ordini'),
                    user.orders.isEmpty
                        ? EmptyCard(title: 'Non ci sono ordini')
                        : HorizontalList(
                            elements: user.orders
                                .map((order) => OrderCard(order: order))
                                .toList())
                  ],
                ))),
        floatingActionButton: _logoutButton());
  }

  Widget _logoutButton() {
    return StoreConnector<AppState, dynamic>(
      converter: (store) => store,
      builder: (_, store) => FloatingActionButton(
        onPressed: () {
          store.dispatch(DeleteUserAccessTokenAction());
          widget.reloadPage(store.state.userAccessToken);
        },
        child: const Icon(Icons.logout_outlined),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _sectionTitle({required String title, IconButton? iconbutton}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
          margin: EdgeInsets.only(bottom: 20, top: 20),
          child: Header(label: title)),
      iconbutton ?? Text('')
    ]);
  }

  Widget _sectionLabelSpacer() {
    return SizedBox(height: 25.0);
  }

  Widget _sectionLabel(List<String> labels) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: labels.map((label) => Text(label)).toList());
  }
}

class EmptyCard extends StatelessWidget {
  final String title;

  EmptyCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
          height: MediaQuery.of(context).size.height / 5.5,
          child: Center(child: Header(label: this.title))),
    );
  }
}
