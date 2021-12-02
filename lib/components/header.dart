import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String label;

  Header({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      this.label,
      overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor));
  }
}
