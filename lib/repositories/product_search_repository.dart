import 'dart:convert';

import 'package:tf/models/product_preview.dart';
import 'package:tf/utils/apiBaseHelper.dart';
import 'package:tf/utils/request.dart';

String _getQueryString(String title) {
  return '''
  {
        products(first: 5, query:"title:*$title*") {
          edges {
            node {
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
        }
      }
''';
}

class ProductSearchRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<ProductPreview>> searchProducts(String title) async {
    final response = await _helper.post(
        headers: Request.headers,
        body: jsonEncode({'query': _getQueryString(title)}));

    final List<dynamic> productEdges = response['data']['products']['edges'];

    return productEdges.map((edge) => ProductPreview.fromJson(edge['node'])).toList();
  }
}