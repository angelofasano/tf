import 'package:flutter/material.dart';
import 'package:tf/components/header.dart';

class Error extends StatelessWidget {
  final VoidCallback onPress;

  Error({required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Center(child: Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        Image.asset('images/error.png'),
        InkWell(
          onTap: this.onPress,
            child: Container(
          // height: this.height / 3,
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Icon(Icons.error,
                size: 40, color: Theme.of(context).primaryColorLight),
            Header(label: 'Si e verificato un errore'),
            Text('Tocca per ricaricare')
          ]),
        ))
      ]),
    ));
  }
}
