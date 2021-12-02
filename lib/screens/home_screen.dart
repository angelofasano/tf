import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tf/components/error.dart';
import 'package:tf/components/homeCard.dart';
import 'package:tf/components/horizontalList.dart';
import 'package:tf/components/productCard.dart';
import 'package:tf/components/staticPageGrid.dart';
import 'package:tf/models/product_preview.dart';
import 'package:tf/redux/actions/updateLastProductsAction.dart';
import 'package:tf/redux/appState.dart';
import 'package:tf/repositories/product_repository.dart';
import 'package:tf/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;
  bool error = false;

  _startLoading() {
    setState(() {
      loading = true;
    });
  }

  _stopLoading() {
    setState(() {
      loading = false;
    });
  }

  _isError() {
    setState(() {
      error = true;
    });
  }

  _isNotError() {
    setState(() {
      error = false;
    });
  }

  _updateLastProducts(store) async {
    try {
      _startLoading();
      List<ProductPreview> products =
          await ProductRepository().getLastProducts();
      store.dispatch(UpdateLastProductAction(lastProducts: products));
      _isNotError();
      _stopLoading();
    } catch (e) {
      _stopLoading();
      _isError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        onInitialBuild: (store) => {
          if(store.state.lastProducts.isEmpty) {
            _updateLastProducts(store)
          }
        },
        builder: (_, store) {
          return Scaffold(
            body: RefreshIndicator(
                onRefresh: () => _updateLastProducts(store),
                child: this.loading
                    ? Center(child: CircularProgressIndicator())
                    : this.error
                        ? Center(
                            child: Error(
                                onPress: () => {_updateLastProducts(store)}))
                        : _onComplete(store.state.lastProducts)),
          );
        });
  }

  Widget _onComplete(List<ProductPreview> products) {
    final List<Widget> productCards = products
        .map((product) => Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: ProductCard(product: product)))
        .toList();

    return SafeArea(
        child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  margin:
                      EdgeInsets.only(left: 20, bottom: 10, top: 10, right: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TF Abbigliamento',
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontWeight: FontWeight.bold),
                            textScaleFactor: 2),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: new AssetImage('images/tf_logo.jpeg'),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ])),
              InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, SearchScreen.routeName);
                  },
                  child: Container(
                      margin: EdgeInsets.only(
                          left: 10, bottom: 10, top: 10, right: 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            side: new BorderSide(
                                color: Theme.of(context).accentColor, width: 2.0),
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Cerca prodotto',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                  Icon(Icons.search, color: Theme.of(context).primaryColorDark)
                                ])),
                      ))),
              HomeCard(
              leading: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                HomeCard.cardTitle('Saldi fino al', Theme.of(context).primaryColorDark),
                CircularPercentIndicator(
              radius: 80.0,
              lineWidth: 6.0,
              animation: true,
              animationDuration: 1200,
              percent: 0.7,
              center: new Text(
                "70.0%",
                style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: Theme.of(context).primaryColor),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Theme.of(context).accentColor,
            )
              ]),
              trailing: Image.asset('images/checkout.png')
              ),
              StaticPageGrid(),
              HomeCard(
              leading: Column(children: [
                HomeCard.cardTitle('Weekly news', Theme.of(context).primaryColorDark),
                HomeCard.cardDescription('Novita ogni settimana', Theme.of(context).accentColor),
              ]),
              trailing: Image.asset('images/news.png')),
              Container(
                  margin: EdgeInsets.only(left: 20, bottom: 10, top: 10),
                  child: Text('Nuovi arrivi'.toUpperCase(),
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ))),
              HorizontalList(elements: productCards),
              HomeCard(
              leading: Column(children: [
                HomeCard.cardTitle('Free delivery', Theme.of(context).primaryColorDark),
                HomeCard.cardDescription('su Taranto e Talsano', Theme.of(context).accentColor),
              ]),
              trailing: Image.asset('images/location.png')),
            ])));
  }
}
