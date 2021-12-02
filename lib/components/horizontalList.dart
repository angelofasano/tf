import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  final List<Widget> elements;

  HorizontalList({required this.elements});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(children: elements)),
    );
  }
}

