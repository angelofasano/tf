import 'package:flutter/material.dart';
import 'package:tf/components/header.dart';
import 'package:tf/models/order.dart';
import 'package:tf/utils/orderArguments.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({Key? key}) : super(key: key);

  static const routeName = '/orderDetail';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as OrderArguments;
    return Scaffold(
      body: OrderDetailView(order: args.order),
    );
  }
}

class OrderDetailView extends StatefulWidget {
  OrderDetailView({Key? key, required this.order}) : super(key: key);

  final Order order;

  @override
  State<OrderDetailView> createState() => _OrderDetailView();
}

class _OrderDetailView extends State<OrderDetailView> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: new Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Header(label: widget.order.name))
              ]),
              Container(
                margin: EdgeInsets.all(10),
                child: ExpansionPanelList(
                  animationDuration: Duration(milliseconds: 500),
                  children: [
                    ExpansionPanel(
                      headerBuilder: (context, isExpanded) {
                        return ListTile(
                            title: Header(label: 'Indirizzo di spedizione'));
                      },
                      body: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                    children: [
                                      Text('Indirizzo'),
                                      Text(
                                          widget.order.shippingAddress.address1)
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween),
                                Spacer(),
                                Row(
                                    children: [
                                      Text('Scala / Interno'),
                                      Text(
                                          widget.order.shippingAddress.address2)
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween),
                                Spacer(),
                                Row(
                                    children: [
                                      Text('Citta'),
                                      Text(widget.order.shippingAddress.city)
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween),
                                Spacer(),
                                Row(
                                    children: [
                                      Text('Azienda'),
                                      Text(widget.order.shippingAddress.company)
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween),
                                Spacer(),
                                Row(
                                    children: [
                                      Text('Paese'),
                                      Text(widget.order.shippingAddress.country)
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween),
                                Spacer(),
                                Row(
                                    children: [
                                      Text('Utente'),
                                      Text(widget
                                              .order.shippingAddress.firstName +
                                          ' ' +
                                          widget.order.shippingAddress.lastName)
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween),
                                Spacer(),
                                Row(
                                    children: [
                                      Text('Telefono'),
                                      Text(widget.order.shippingAddress.phone)
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween),
                                Spacer(),
                                Row(
                                    children: [
                                      Text('Provincia'),
                                      Text(
                                          widget.order.shippingAddress.province)
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween),
                                Spacer(),
                                Row(
                                    children: [
                                      Text('Codice postale'),
                                      Text(widget.order.shippingAddress.zip)
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween),
                              ])),
                      isExpanded: _expanded,
                      canTapOnHeader: true,
                    ),
                  ],
                  dividerColor: Theme.of(context).primaryColorDark,
                  expansionCallback: (panelIndex, isExpanded) {
                    _expanded = !_expanded;
                    setState(() {});
                  },
                ),
              ),
              
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Flexible(flex: 2, child: Header(label: 'Nome')),
                          Flexible(flex: 2, child: Header(label: 'Quantita')),
                          Flexible(flex: 2, child: Header(label: 'Prezzo'))
                        ])),
              
              Container(
                  height: 200,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: ListView.builder(
                      itemCount: widget.order.lineItems.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Flexible(child: Text(widget.order.lineItems[index].title)),
                          Flexible(child: Text(widget.order.lineItems[index].quantity.toString())),
                          Flexible(child: Text('${num.parse(widget.order.lineItems[index].price).toStringAsFixed(2)} €'))
                        ]);
                      })))
            ],
          ),
        )),
      ),
    );
  }
}

class Spacer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.0,
    );
  }
}
