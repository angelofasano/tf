import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        child: Container(
            child: Center(
                child: Column(children: [
          Lottie.asset('images/empty.json'),
          Card(
              margin: EdgeInsets.all(20),
              child: Container(
                  padding: EdgeInsets.all(40),
                  child: Text(
                      'Siamo spiacenti. Questa collezione è in fase di aggiornamento e non contiene articoli.')))
        ]))),
      ),
    ]));
  }
}
