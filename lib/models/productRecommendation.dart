import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tf/models/product_preview.dart';
import 'package:tf/utils/request.dart';

String _queryBuilder(String productID) {
  return """
      {
        productRecommendations(productId:"$productID") {
          id,
          title,
          description,
          availableForSale,
          images(first: 1) {
              edges {
                  node {
                      originalSrc
                  }
              }
          },
          compareAtPriceRange{
          minVariantPrice{amount},
          maxVariantPrice{amount}
          }
          priceRange{
            minVariantPrice{amount},
            maxVariantPrice{amount}
          }
        }
      }
    """;
}

Future<List<ProductPreview>> fetchProducts({required String productID}) async {
  final response = await http.post(Request.url,
      headers: Request.headers,
      body: json.encode({'query': _queryBuilder(productID)}));

  if (response.statusCode == 200) {
    final dynamic data = jsonDecode(response.body)['data'];

    final List<dynamic> recommendations = data['productRecommendations'];
    final List<ProductPreview> products = recommendations
        .map((recommendation) => ProductPreview.fromJson(recommendation))
        .toList();

    return products;
  } else {
    throw Exception('Failed to load recommendations');
  }
}
