import 'package:flutter/material.dart';
import 'package:tf/models/address.dart';
import 'package:tf/screens/address_update_screen.dart';
import 'package:tf/utils/addressUpdateArguments.dart';

import 'header.dart';

class AddressCard extends StatelessWidget {
  final Address address;
  final String token;
  final bool isDefault;
  final Function successCallback;
  AddressCard(
      {required this.address, required this.isDefault, required this.token, required this.successCallback});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: this.isDefault
          ? new RoundedRectangleBorder(
              side: new BorderSide(
                  color: Theme.of(context).primaryColor, width: 2.0),
              borderRadius: BorderRadius.circular(4.0))
          : new RoundedRectangleBorder(
              side: new BorderSide(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.circular(4.0)),
      child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AddressUpdateScreen.routeName,
                    arguments:
                        AddressUpdateArguments(address, isDefault, token, successCallback),
                  );
                },
                child: Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 381,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Header(label: address.address1),
                          Row(children: [
                            Text('Indirizzo'),
                            Text(address.address1)
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                          Row(children: [
                            Text('Scala / Interno'),
                            Text(address.address2)
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                          Row(children: [
                            Text('Citta'),
                            Text(address.city)
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                          Row(children: [
                            Text('Azienda'),
                            Text(address.company)
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                          Row(children: [
                            Text('Paese'),
                            Text(address.country)
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                          Row(children: [
                            Text('Utente'),
                            Text(address.firstName + ' ' + address.lastName)
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                          Row(children: [
                            Text('Telefono'),
                            Text(address.phone)
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                          Row(children: [
                            Text('Provincia'),
                            Text(address.province)
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                          Row(children: [
                            Text('Codice postale'),
                            Text(address.zip)
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                        ])),
              )
            ],
          )),
    );
  }
}
