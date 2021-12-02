import 'dart:convert';

import 'package:tf/models/address.dart';
import 'package:tf/models/lineItem.dart';
import 'package:tf/models/shippingRate.dart';
import 'package:tf/utils/apiBaseHelper.dart';
import 'package:tf/utils/request.dart';

class CheckoutRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<void> setShippingRate(String handle, String checkoutID) async {
    String query = '''
    mutation checkoutShippingLineUpdate(\$checkoutId: ID!, \$shippingRateHandle: String!) {
      checkoutShippingLineUpdate(checkoutId: \$checkoutId, shippingRateHandle: \$shippingRateHandle) {
        checkout {
          id
        }
        checkoutUserErrors {
          code
          field
          message
        }
      }
    }
    ''';

    try {
      final response = await _helper.post(
          headers: Request.headers,
          body: jsonEncode({
            'query': query,
            'variables': {
              "shippingRateHandle": handle,
              "checkoutId": checkoutID
            }
          }));

      List<dynamic> errors =
          response['data']['checkoutShippingLineUpdate']['checkoutUserErrors'];
      if (errors.isEmpty) {
        return;
      } else {
        throw Exception(errors.toString());
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> associateCustomer(
      String userAccessToken, String checkoutID) async {
    String query = '''
    mutation associateCustomerWithCheckout(\$checkoutId: ID!, \$customerAccessToken: String!) {
      checkoutCustomerAssociateV2(checkoutId: \$checkoutId, customerAccessToken: \$customerAccessToken) {
        checkout {
          id
        }
        checkoutUserErrors {
          code
          field
          message
        }
        customer {
          id
        }
      }
    }
    ''';

    try {
      final response = await _helper.post(
          headers: Request.headers,
          body: jsonEncode({
            'query': query,
            'variables': {
              "customerAccessToken": userAccessToken,
              "checkoutId": checkoutID
            }
          }));

      List<dynamic> errors =
          response['data']['checkoutCustomerAssociateV2']['checkoutUserErrors'];
      if (errors.isEmpty) {
        return;
      } else {
        throw Exception(errors.toString());
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<ShippingRateResponse> getShippingRates(String checkoutID) async {
    String query = '''
    query {
        node(id: "$checkoutID") {
        ... on Checkout {
            id
            webUrl
            availableShippingRates {
              ready
              shippingRates {
                handle
                priceV2 {
                  amount
                }
                title
              }
            }
          }
        }
      }
    ''';

    try {
      final response = await _helper.post(
          headers: Request.headers, body: jsonEncode({'query': query}));
      print(response);
      final bool ready =
          response['data']['node']['availableShippingRates']['ready'];
      final List<ShippingRate> shippingRates = response['data']['node']
                  ['availableShippingRates']['shippingRates'] !=
              null
          ? ShippingRate.fromList(response['data']['node']
              ['availableShippingRates']['shippingRates'])
          : [];
      return ShippingRateResponse(ready, shippingRates);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateShippingAddress(
      Address shippingAddress, String checkoutID) async {
    String query = '''
      mutation checkoutShippingAddressUpdateV2(\$shippingAddress: MailingAddressInput!, \$checkoutId: ID!) {
        checkoutShippingAddressUpdateV2(shippingAddress: \$shippingAddress, checkoutId: \$checkoutId) {
          userErrors {
            field
            message
          }
          checkout {
            id
          }
        }
      }
    ''';

    try {
      final response = await _helper.post(
          headers: Request.headers,
          body: jsonEncode({
            'query': query,
            'variables': {
              "shippingAddress": shippingAddress.toJson(),
              "checkoutId": checkoutID
            }
          }));

      final List<dynamic> errors =
          response['data']['checkoutShippingAddressUpdateV2']['userErrors'];

      if (errors.isEmpty) {
        return;
      } else {
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
      throw Exception();
    }
  }

  Future<CheckoutResponse> checkoutUpdate(
      List<LineItem> lineItems, String checkoutID) async {
    String query = '''
      mutation(\$lineItems: [CheckoutLineItemInput!]!, \$checkoutId:ID!) {
      checkoutLineItemsReplace(
          lineItems:\$lineItems,
          checkoutId:\$checkoutId
      ) {
        checkout {
           id
           webUrl
        }
      }
    }
    ''';
    final response = await _helper.post(
        headers: Request.headers,
        body: jsonEncode({
          'query': query,
          'variables': {
            "lineItems": lineItems.map((i) => i.toJson()).toList(),
            "checkoutId": checkoutID
          }
        }));

    final dynamic data = response['data'];
    return CheckoutResponse(data['checkoutLineItemsReplace']['checkout']['id'],
        data['checkoutLineItemsReplace']['checkout']['webUrl']);
  }

  Future<CheckoutResponse> checkoutCreate(List<LineItem> lineItems) async {
    String query = '''
      mutation(\$lineItems: [CheckoutLineItemInput!]) {
      checkoutCreate(input: {
        lineItems: \$lineItems
        }) {
          checkout {
              id
              webUrl
          }
        }
      }
    ''';
    final response = await _helper.post(
        headers: Request.headers,
        body: jsonEncode({
          'query': query,
          'variables': {
            "lineItems": lineItems.map((i) => i.toJson()).toList(),
          }
        }));

    final dynamic data = response['data'];
    return CheckoutResponse(data['checkoutCreate']['checkout']['id'],
        data['checkoutCreate']['checkout']['webUrl']);
  }
}

class CheckoutResponse {
  final String id;
  final String webUrl;

  CheckoutResponse(this.id, this.webUrl);
}

class ShippingRateResponse {
  final bool ready;
  final List<ShippingRate> shippingRates;
  ShippingRateResponse(this.ready, this.shippingRates);
}
