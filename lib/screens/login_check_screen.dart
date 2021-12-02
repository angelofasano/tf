import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tf/bloc/login_check_bloc.dart';
import 'package:tf/redux/appState.dart';
import 'package:tf/screens/login_screen.dart';
import 'package:tf/screens/user_screen.dart';
import 'package:tf/utils/apiResponse.dart';

class LoginCheckScreen extends StatefulWidget {
  @override
  _LoginCheckState createState() => _LoginCheckState();
}

class _LoginCheckState extends State<LoginCheckScreen> {
  late LoginCheckBloc _bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        onInit: (store) => {_bloc = LoginCheckBloc(store.state.userAccessToken)},
        builder: (_, store) => Scaffold(
              body: StreamBuilder<ApiResponse<bool>>(
                  stream: _bloc.userLoggedStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status) {
                        case Status.LOADING:
                          return const Center(
                              child: CircularProgressIndicator());
                        case Status.COMPLETED:
                          if (snapshot.data!.data!) {
                            return UserScreen(reloadPage: (accessToken) => {
                              _bloc.checkIfUserIsLogged(accessToken)
                            });
                          } else {
                            return LoginScreen(reloadPage: (accessToken) => {
                              _bloc.checkIfUserIsLogged(accessToken)
                            });
                          }
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
}
