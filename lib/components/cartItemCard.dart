import 'package:flutter/material.dart';
import 'package:tf/models/cartItem.dart';
import 'package:tf/screens/product_detail_screen.dart';
import 'package:tf/utils/productArguments.dart';

import 'header.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  CartItemCard({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    VoidCallback onTap = () {
      Navigator.pushNamed(
        context,
        ProductDetailScreen.routeName,
        arguments: ProductArguments(this.cartItem.productID),
      );
    };

    return cartItem.quantity != 0
        ? _cartCard(context, onTap, Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text('Quantita: '),
                        Text(this.cartItem.quantity.toString())
                      ]))
        : _disabledCard(context, () => {}, Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text('ESAURITO'),
                      ]));
  }

  Widget _disabledCard(context, VoidCallback onTap, Widget lastRow) {
    return Container(
      foregroundDecoration: BoxDecoration(
        color: Colors.grey,
        backgroundBlendMode: BlendMode.saturation,
      ),
      child: _cartCard(context, onTap, lastRow),
    );
  }

  Widget _cartCard(context, VoidCallback onTap, Widget lastRow) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
              onTap: onTap,
              child: ListTile(
                minVerticalPadding: 20,
                leading: ClipOval(
                  child: Container(
                      width: 78.0,
                      height: 78.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(cartItem.image)))),
                ),
                title: Header(label: cartItem.productTitle),
                trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        '${(cartItem.price * cartItem.quantity).toStringAsFixed(2)} €',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ]),
                subtitle: Column(children: [
                  Row(children: [Text(cartItem.variantTitle)]),
                  lastRow
                ]),
              )),
        ],
      ),
    );
  }
}
