import 'dart:convert';

import 'package:tf/models/lineItem.dart';
import 'package:tf/utils/apiBaseHelper.dart';
import 'package:tf/utils/request.dart';

class VariantRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<Map<String, int>> checkVariantsAvailability(
      List<LineItem> lineItems) async {
    String query = '''
      query nodes(\$ids: [ID!]!) {
            nodes(ids: \$ids) {
              ... on ProductVariant {
                id,
                quantityAvailable
              }
            }
          }
    ''';
    final response = await _helper.post(
        headers: Request.headers,
        body: jsonEncode({
          'query': query,
          'variables': {
            "ids": [...lineItems.map((item) => item.id)]
          }
        }));

    final dynamic data = response['data'];
    final List<dynamic> nodes = data['nodes'];

    final Map<String, int> inventoryDifferences = new Map();
    lineItems.forEach((element) {
      int addedQuantity = element.quantity;
      int availableQuantity = nodes
          .firstWhere((node) => node['id'] == element.id)['quantityAvailable'];

      if(availableQuantity == 0) {
        inventoryDifferences[element.id] = 0;
      }
      else if (addedQuantity > availableQuantity) {
        inventoryDifferences[element.id] = (addedQuantity - (addedQuantity - availableQuantity));
      }
    });

    return inventoryDifferences;
  }
}
