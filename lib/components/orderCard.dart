import 'package:flutter/material.dart';
import 'package:tf/models/order.dart';
import 'package:tf/screens/order_detail_screen.dart';
import 'package:tf/utils/orderArguments.dart';

import 'header.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  OrderCard({required this.order});

  final financialStatusTranslates = {
    'PENDING': 'In attesa',
    'AUTHORIZED': 'Autorizzato',
    'PARTIALLY_PAID': 'Parzialmente pagato',
    'PARTIALLY_REFUNDED': 'Parzialmente rimborsato',
    'VOIDED': 'Vuoto',
    'PAID': 'Pagato',
    'REFUNDED': 'Rimborsato',
  };

  final orderFullFillmentTranslates = {
    'UNFULFILLED': 'Non evaso',
    'PARTIALLY_FULFILLED': 'Evaso parzialmente',
    'FULFILLED': 'Evaso',
    'RESTOCKED': 'Rifornito',
    'PENDING_FULFILLMENT': 'Evasione in attesa',
    'OPEN': 'Aperto',
    'IN_PROGRESS': 'In corso',
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    OrderDetailScreen.routeName,
                    arguments:
                        OrderArguments(this.order),
                  );
                },
                child: Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 381,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Header(label: order.name),
                          Row(children: [
                            Text('Stato finanziario'),
                            Text(this.financialStatusTranslates[this.order.financialStatus]!)
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                          Row(children: [
                            Text('Stato evasione'),
                            Text(this.orderFullFillmentTranslates[this.order.fulfillmentStatus]!)
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                          Row(children: [
                            Text('Importo'),
                            Text('${num.parse(this.order.amount).toStringAsFixed(2)} €')
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                          Row(children: [
                            Text('Numero ordine'),
                            Text(order.orderNumber)
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                        ])),
              )
            ],
          )),
    );
  }
}
