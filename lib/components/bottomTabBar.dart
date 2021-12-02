import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tf/models/cartItem.dart';
import 'package:tf/redux/appState.dart';
import 'package:tf/screens/home_screen.dart';
import 'package:tf/screens/cart_screen.dart';
import 'package:tf/screens/favorite_screen.dart';
import 'package:tf/screens/login_check_screen.dart';
import 'package:tf/screens/menu_screen.dart';
import 'package:tf/services/bar_index_service.dart';

class BottomTabBar extends StatefulWidget {
  BottomTabBar({Key? key, required this.title}) : super(key: key);

  final String title;
  final BarIndexService _barIndexService = BarIndexService();

  @override
  State<BottomTabBar> createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar> {
  void _onItemTapped(int index) {
    setState(() {
      widget._barIndexService.update(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (_, store) => Scaffold(
      body: Center(
        child: <Widget>[
          HomeScreen(),
          LoginCheckScreen(),
          MenuScreen(),
          FavoriteScreen(),
          CartScreen()
        ].elementAt(widget._barIndexService.index),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget._barIndexService.index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.cottage_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Utente'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), label: 'Preferiti'),
          BottomNavigationBarItem(icon: new Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                new Icon(Icons.shopping_cart_outlined),
                store.state.cart.length > 0 ? _badge(_getCartItems(store)) : Text('')
              ],
            ), label: 'Carrello')
        ],
        selectedItemColor: Theme.of(context).primaryColorDark,
        unselectedItemColor: Theme.of(context).primaryColorDark,
        onTap: _onItemTapped,
      ),
    ));
  }

  int _getCartItems(store) {
    List<CartItem> items = store.state.cart;
    return items.fold(
        0, (previousValue, element) => previousValue + element.quantity);
  }

    Widget _badge(int items) {
    return Positioned(
      top: -10,
      right: -10,
      child: Container(
        alignment: Alignment.topLeft,
      decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(1000)),
      height: 20,
      width: 20,
      child: Center(
          child: Text(
        items.toString(),
        style: TextStyle(color: Colors.white, fontSize: 11),
      )),
    ));
  }
}
