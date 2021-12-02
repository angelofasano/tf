import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tf/components/cartItemCard.dart';
import 'package:tf/components/loadDialog.dart';
import 'package:tf/models/cartItem.dart';
import 'package:tf/models/lineItem.dart';
import 'package:tf/redux/actions/deleteCartAction.dart';
import 'package:tf/redux/actions/updateCartAction.dart';
import 'package:tf/redux/appState.dart';
import 'package:tf/repositories/checkout_repository.dart';
import 'package:tf/repositories/login_check_repository.dart';
import 'package:tf/repositories/user_repository.dart';
import 'package:tf/repositories/variant_repository.dart';
import 'package:tf/screens/checkout_screen.dart';
import 'package:tf/screens/web_checkout_screen.dart';
import 'package:tf/services/bar_index_service.dart';
import 'package:tf/utils/checkoutArguments.dart';
import 'package:tf/utils/webCheckoutArguments.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String checkoutID = '';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (_, store) => Scaffold(
              floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
              body: (store.state.cart as List<CartItem>).isEmpty
                  ? Stack(children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Image.asset('images/cart.png'),
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height / 15),
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(color: Colors.transparent),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                  padding: EdgeInsets.all(30),
                                  child: Text(
                                    'Non hai aggiunto articoli nel carrello',
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.bold),
                                  ))))
                    ])
                  : Column(children: [
                      Expanded(
                          child: ListView(
                              children: (store.state.cart as List<CartItem>)
                                  .map((p) => Dismissible(
                                      confirmDismiss:
                                          (DismissDirection direction) async {
                                        return await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Elimina'),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    Text(
                                                        'Sei sicuro di voler eliminare ${p.productTitle}')
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text('Annulla'),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(false);
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text('Conferma'),
                                                  onPressed: () {
                                                    store.dispatch(
                                                        DeleteCartAction(
                                                            productVariantID:
                                                                p.variantID));
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      key: Key(p.variantID),
                                      direction: DismissDirection.endToStart,
                                      background: Card(
                                          margin: EdgeInsets.all(10),
                                          child: Center(
                                              child: Text('Elimina',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white))),
                                          color: Colors.red),
                                      child: CartItemCard(cartItem: p)))
                                  .toList())),
                      _bottomHeader(store)
                    ]),
            ));
  }

  double getTotal(store) {
    return (store.state.cart as List<CartItem>)
        .fold(0, (val, item) => val + item.price * item.quantity);
  }

  Widget _bottomHeader(store) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: 90,
      child: Row(
        children: [
          Flexible(
              flex: 8,
              child: InkWell(
                onTap: () {
                  goToCheckout(store);
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.all(15),
                    child: Center(
                        child: Text(
                      'Checkout'.toUpperCase(),
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ))),
              )),
          Flexible(
              flex: 3,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  padding: EdgeInsets.all(15),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('TOTALE'),
                        Text(
                          '${getTotal(store).toStringAsFixed(2)} €',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ])))
        ],
      ),
    );
  }

  loginAndCheckout(store) async {
    final bool userIsLogged = await LoginCheckRepository()
        .checkIfUserIsLogged(store.state.userAccessToken);

    if (userIsLogged) {
      final checkoutResponse = this.checkoutID == ''
          ? await CheckoutRepository()
              .checkoutCreate(LineItem.fromCartItems(store.state.cart))
          : await CheckoutRepository().checkoutUpdate(
              LineItem.fromCartItems(store.state.cart), this.checkoutID);

      this.setState(() {
        checkoutID = checkoutResponse.id;
      });

      await CheckoutRepository()
          .associateCustomer(store.state.userAccessToken, checkoutID);
      // final user = await UserRepository().getUser(store.state.userAccessToken);
      Navigator.pop(context);
      Navigator.pushNamed(context, WebCheckoutScreen.routeName,
          arguments: WebCheckoutArguments(checkoutResponse.webUrl, store.state.userAccessToken));
    } else {
      continueAsGuest(store);
    }
  }

  showWarningAndUpdate(
      Map<String, int> variantsAvailable, List<CartItem> cartItems, store) {
    {
      variantsAvailable.forEach((key, value) {
        CartItem item =
            cartItems.firstWhere((element) => element.variantID == key);

        store.dispatch(UpdateCartAction(
            item: new CartItem(
                item.variantID,
                item.productTitle,
                item.productID,
                item.variantTitle,
                item.price,
                item.image,
                value)));
      });
      Navigator.pop(context);
      this.showWarningSnackBar();
    }
  }

  showWarningSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(days: 1),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.black87,
          onPressed: () {
            Scaffold.of(context).hideCurrentSnackBar();
          },
        ),
        content: Text(
            '''Attenzione! i prodotti richiesti non sono disponibili nel nostro inventario.

Le quantità sono state adattate automaticamente.''',
            style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.yellow,
        elevation: 1000,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  goToCheckout(store) async {
    ShowDialog.show(context);

    try {
      final List<CartItem> cartItems = store.state.cart;
      final Map<String, int> variantsAvailable = await VariantRepository()
          .checkVariantsAvailability(LineItem.fromCartItems(store.state.cart));
      variantsAvailable.isNotEmpty
          ? showWarningAndUpdate(variantsAvailable, cartItems, store)
          : loginAndCheckout(store);
    } catch (e) {
      Navigator.pop(context);
      print(e.toString());
    }
  }

  continueAsGuest(store) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Non hai ancora effettuato il login'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[Text('Vuoi continuare come ospite?')],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Continua come ospite'),
              onPressed: () async {
                Navigator.of(context).pop();
                final checkoutResponse = this.checkoutID == ''
                    ? await CheckoutRepository().checkoutCreate(
                        LineItem.fromCartItems(store.state.cart))
                    : await CheckoutRepository().checkoutUpdate(
                        LineItem.fromCartItems(store.state.cart),
                        this.checkoutID);

                this.setState(() {
                  checkoutID = checkoutResponse.id;
                });
                Navigator.of(this.context).pop();
                Navigator.pushNamed(this.context, WebCheckoutScreen.routeName,
                     arguments: WebCheckoutArguments(checkoutResponse.webUrl, store.state.userAccessToken));
              },
            ),
            TextButton(
              child: const Text('Vai al Login'),
              onPressed: () {
                BarIndexService().update(1);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }
}
