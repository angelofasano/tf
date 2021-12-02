import 'package:flutter/material.dart';

class ShowDialog {
  static show(context) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Attendere....",
                          style: TextStyle(color: Theme.of(context).accentColor),
                        )
                      ]),
                    )
                  ]));
        });
  }
}