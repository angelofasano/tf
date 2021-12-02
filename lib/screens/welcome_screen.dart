import 'package:flutter/material.dart';
import 'package:tf/services/bar_index_service.dart';

class WelcomeScreen extends StatelessWidget {
  static String routeName = '/welcome';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            image: DecorationImage(
              image: AssetImage("images/welcome.png"),
              fit: BoxFit.contain,
            ),
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
              child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Benvenuto su TF',
                  textScaleFactor: 3,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                InkWell(
                    onTap: () {
                      BarIndexService().update(0);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/', (Route<dynamic> route) => false);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Text(
                              'Torna alla home',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                  fontWeight: FontWeight.bold),
                            ))))
              ],
            ),
          ))),
    ]));
  }
}
