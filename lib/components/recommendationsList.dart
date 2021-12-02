import 'package:flutter/material.dart';
import 'package:tf/components/productCard.dart';
import 'package:tf/models/productRecommendation.dart';
import 'package:tf/components/error.dart';
import 'package:tf/models/product_preview.dart';
import 'horizontalList.dart';

class RecommendationsList extends StatefulWidget {
  RecommendationsList({Key? key, required this.productID}) : super(key: key);

  final String productID;

  @override
  State<RecommendationsList> createState() => _RecommendationsListState();
}

class _RecommendationsListState extends State<RecommendationsList> {
  late Future<List<ProductPreview>> recommendedProducts;

  @override
  void initState() {
    super.initState();
    recommendedProducts = fetchProducts(productID: widget.productID);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductPreview>>(
      future: recommendedProducts,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(child: Text('Input a URL to start'));
          case ConnectionState.waiting:
            return Center(child: Padding(
                            padding: EdgeInsets.only(
                                top: 50),
                            child: CircularProgressIndicator()));
          case ConnectionState.active:
            return Center(child: Text('active'));
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Error(
                  onPress: () => {
                        this.setState(() {
                          recommendedProducts =
                              fetchProducts(productID: widget.productID);
                        })
                      });
            } else {
              final List<Widget> productCards = snapshot.data!
                  .map((product) => Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: 
                      ProductCard(product: product)
                      
                      ))
                  .toList();

              return HorizontalList(elements: productCards);
            }
        }
      },
    );
  }
}
