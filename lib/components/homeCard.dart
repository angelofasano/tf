import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final Widget leading;
  final Widget trailing;

  static Widget cardTitle(String title, Color color) {
    return Text(title.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 20,
        ));
  }

  static Widget cardDescription(String description, Color color) {
    return Text(description,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ));
  }

  HomeCard({required this.trailing, required this.leading});

  @override
  Widget build(BuildContext context) {
    final Decoration decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(
              .0,
              0,
            ),
            blurRadius: 10.0,
            spreadRadius: 0.0,
          )
        ],
        gradient: new LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Theme.of(context).primaryColorLight,
            ]));

    final double height = MediaQuery.of(context).size.height / 5;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
      height: height,
      width: width,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: decoration,
        child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: leading), 
              Flexible(child: trailing)
            ]),
      ),
    );
  }
}
