import 'package:flutter/material.dart';
import 'package:tf/models/product_preview.dart';
import 'package:tf/screens/product_detail_screen.dart';
import 'package:tf/utils/productArguments.dart';

import 'header.dart';

class ListProductCard extends StatelessWidget {
  final ProductPreview product;
  ListProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  ProductDetailScreen.routeName,
                  arguments: ProductArguments(this.product.id),
                );
              },
              child: ListTile(
                minVerticalPadding: 20,
                leading: ClipOval(
                  child: Container(
                      width: 78.0,
                      height: 78.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  product.image)))),
                ),
                title: Header(label: product.title),
                subtitle: Text(product.description),
              )),
        ],
      ),
    );
  }
}
