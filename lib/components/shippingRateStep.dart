import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tf/components/loadDialog.dart';
import 'package:tf/models/shippingRate.dart';
import 'package:tf/repositories/checkout_repository.dart';

class ShippingRateStep extends StatefulWidget {
  ShippingRateStep(
      {required this.checkoutID,
      required this.onBack,
      required this.successCallback});
  final String checkoutID;
  final Function onBack;
  final Function successCallback;
  @override
  State<ShippingRateStep> createState() => _ShippingRateStepState();
}

class _ShippingRateStepState extends State<ShippingRateStep> {
  bool loading = true;
  List<ShippingRate> shippingRates = [];
  String? selectedShippingRate;

  @override
  void initState() {
    super.initState();
    loadShippingRates();
  }

  void loadShippingRates() {
    Timer.periodic(
        Duration(seconds: 1),
        (timer) => {
              CheckoutRepository()
                  .getShippingRates(widget.checkoutID)
                  .then((response) => {
                        if (response.ready)
                          {
                            this.setState(() {
                              this.loading = false;
                              shippingRates = response.shippingRates;
                              selectedShippingRate =
                                  response.shippingRates[0].handle;
                            }),
                            timer.cancel()
                          }
                      })
            });
  }

  @override
  Widget build(BuildContext context) {
    return this.loading
        ? Center(child: CircularProgressIndicator())
        : Center(
            child: Column(children: [
            Container(
                width: MediaQuery.of(context).size.width,
                child: DropdownButton<String>(
                  value: this.shippingRates[0].handle,
                  items: this
                      .shippingRates
                      .map((rate) => rate.handle)
                      .toList()
                      .map((option) =>
                          DropdownMenuItem(value: option, child: Text(option)))
                      .toList(),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                  underline: Container(
                    height: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      this.selectedShippingRate = newValue;
                    });
                  },
                )),
            SizedBox(height: 20),
            Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        widget.onBack();
                      },
                      child: Text('Indietro')),
                  ElevatedButton(
                      onPressed: () {
                        ShowDialog.show(context);
                        CheckoutRepository()
                            .setShippingRate(
                                this.selectedShippingRate!, widget.checkoutID)
                            .then((_) => {
                              Navigator.of(context).pop(),
                              widget.successCallback()
                            });
                      },
                      child: Text('Avanti'))
                ])
          ]));
  }
}
