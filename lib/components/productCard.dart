import 'package:flutter/material.dart';
import 'package:tf/components/header.dart';
import 'package:tf/models/product_preview.dart';
import 'package:tf/screens/product_detail_screen.dart';
import 'package:tf/utils/productArguments.dart';

class ProductCard extends StatelessWidget {
  final ProductPreview product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            ProductDetailScreen.routeName,
            arguments: ProductArguments(this.product.id),
          );
        },
        child: Card(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Image.network(
                    this.product.image,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, widget, loadingProgress) {
                      return loadingProgress == null
                          ? widget
                          : Container(
                              height: MediaQuery.of(context).size.height / 3,
                              width: MediaQuery.of(context).size.width / 2,
                              color: Colors.grey.shade200,
                            );
                    },
                    errorBuilder: (context, obj, stack) {
                      return Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width / 2,
                        color: Colors.grey.shade200,
                        child: Icon(Icons.error, size: 30),
                      );
                    },
                  )),
              Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: Row(children: [
                            Expanded(child: Header(label: this.product.title))
                          ])),
                          product.isOnSale()
                              ? Row(children: [
                                  Text(product.fullPrice(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          decoration:
                                              TextDecoration.lineThrough, color: Theme.of(context).accentColor)),
                                  Container(
                                      margin: EdgeInsets.only(left: 10),
                                      padding: EdgeInsets.all(5),
                                      child: Text(product.price(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white)),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .primaryColorDark))
                                ])
                              : Text(product.price(),
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700, color: Theme.of(context).accentColor)),
                          product.availableForSale
                              ? SizedBox.shrink()
                              : Container(
                                  margin: EdgeInsets.only(top: 5),
                                  padding: EdgeInsets.all(5),
                                  color: Theme.of(context).primaryColorLight,
                                  child: Text('Esaurito'.toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white)))
                        ]),
                  )),
            ])));
  }
}
