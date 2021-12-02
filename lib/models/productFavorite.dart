import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tf/models/product.dart';
import 'package:tf/utils/request.dart';

class ProductFavorite {
  static queryBuilder() {
    return """
      query nodes(\$ids: [ID!]!) {
        nodes(ids: \$ids) {
          ... on Product {
            id,
            title,
            description,
            images(first: 10) {
                edges {
                    node {
                        originalSrc,
                        transformedSrc(crop:CENTER, maxHeight:50, maxWidth: 50),
                        width,
                        height
                    }
                }
            },
            variants(first: 50) {
                edges {
                  node {
                      id,
                      selectedOptions{name, value},
                      quantityAvailable,
                      availableForSale,
                      title,
                      priceV2{amount},
                      image{
                        originalSrc,
                        transformedSrc(crop:CENTER, maxHeight:50, maxWidth: 50),
                        width,
                        height
                        }
                  }
                }
            },
            compareAtPriceRange{maxVariantPrice{amount}}
            priceRange{maxVariantPrice{amount}}
          }
        }
      }
    """;
  }

  final List<Product> products;

  ProductFavorite({required this.products});
}

Future<ProductFavorite> fetchProducts({required List<String> ids}) async {
  final response = await http.post(Request.url,
      headers: Request.headers,
      body: json
          .encode({
          'query': ProductFavorite.queryBuilder(), 
          'variables': {
            'ids': [...ids]
          }
          }));

  if (response.statusCode == 200) {
    final dynamic data = jsonDecode(response.body)['data'];

    final List<dynamic> favorites = data['nodes'];
    final List<Product> products = favorites
        .map((favorite) => Product.fromJson(favorite))
        .toList();

    return ProductFavorite(products: products);
  } else {
    throw Exception('Failed to load favorites');
  }
}
