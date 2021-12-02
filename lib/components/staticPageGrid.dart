import 'package:flutter/material.dart';
import 'package:tf/screens/delivery_screen.dart';
import 'package:tf/screens/save_money_screen.dart';
import 'package:tf/screens/size_guide_screen.dart';

class StaticPageGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Decoration decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.transparent,
      // boxShadow: [
      //   BoxShadow(
      //     color: Colors.grey.shade300,
      //     offset: const Offset(
      //       .0,
      //       0,
      //     ),
      //     blurRadius: 10.0,
      //     spreadRadius: 0.0,
      //   )
      // ]
    );

    final double height = MediaQuery.of(context).size.height / 5;

    return Container(
        padding: EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
        height: height,
        width: MediaQuery.of(context).size.width,
        child: Container(
          decoration: decoration,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _gridItem(
                  context,
                  'size_guide.png',
                  'Guida alle taglie',
                  () => {
                        Navigator.pushNamed(
                          context,
                          SizeGuideScreen.routeName,
                        )
                      }),
              _gridItem(
                  context,
                  'save_money.png',
                  'Resi',
                  () => {
                        Navigator.pushNamed(
                          context,
                          SaveMoneyScreen.routeName,
                        )
                      }),
              _gridItem(
                  context,
                  'delivery.png',
                  'Spedizioni',
                  () => {
                        Navigator.pushNamed(
                          context,
                          DeliveryScreen.routeName,
                        )
                      })
            ],
          ),
        ));
  }

  Widget _gridItem(context, String image, String label, VoidCallback onTap) {
    return Expanded(
        child: InkWell(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          width: 1, color: Theme.of(context).primaryColorDark),
                      bottom: BorderSide(
                          width: 1,
                          color: Theme.of(context).primaryColorDark))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1000),
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
                        ]),
                    height: 100,
                    width: 100,
                    child: Image.asset('images/$image'),
                  ),
                  Text(label,
                      style: (TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).accentColor)))
                ],
              ),
            )));
  }
}
