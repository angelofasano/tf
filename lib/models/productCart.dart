import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tf/models/variant.dart';
import 'package:tf/utils/request.dart';

class ProductCart {
  static queryBuilder() {
    return """
      query nodes(\$ids: [ID!]!) {
      nodes(ids: \$ids) {
          ... on ProductVariant {
            id,
            selectedOptions{name, value},
            quantityAvailable
            title,
            availableForSale,
            priceV2{amount},
            image{
              originalSrc, 
              transformedSrc(crop:CENTER, maxHeight:50, maxWidth: 50)
              width,
              height
              }
          }
      }
    }
    """;
  }

  final List<Variant> productVariants;

  ProductCart({required this.productVariants});
}

Future<ProductCart> fetchProducts(
    {required List<String> productVariantIDs}) async {
  final response = await http.post(Request.url,
      headers: Request.headers,
      body: json.encode({
        'query': ProductCart.queryBuilder(),
        'variables': {
          'ids': [...productVariantIDs]
        }
      }));

  if (response.statusCode == 200) {
    final dynamic data = jsonDecode(response.body)['data'];
    final List<dynamic> productVariants = data['nodes'];
    final List<Variant> variants =
        productVariants.map((item) => Variant.fromJson(item)).toList();

    return ProductCart(productVariants: variants);
  } else {
    throw Exception('Failed to load cart');
  }
}
