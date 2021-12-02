import 'dart:convert';
import 'package:tf/models/customerUserError.dart';
import 'package:tf/utils/apiBaseHelper.dart';
import 'package:tf/utils/request.dart';

class AddressUpdateRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<String> updateAddress(String token, String id, dynamic address) async {
    final String query = '''
    mutation customerAddressUpdate(\$customerAccessToken: String!, \$id: ID!, \$address: MailingAddressInput!) {
      customerAddressUpdate(
        customerAccessToken: \$customerAccessToken
        id: \$id
        address: \$address
      ) {
        customerAddress {
          id
        }
        customerUserErrors {
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
          body: json.encode({
            'query': query,
            'variables': {
              "customerAccessToken": token,
              "id": id,
              "address": address
            }
          }));

      final List<CustomerUserError> errors = CustomerUserError.listFromJson(
          response['data']['customerAddressUpdate']['customerUserErrors']);
      return errors.isEmpty ? response['data']['customerAddressUpdate']['customerAddress']['id'] : throw Exception();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> deleteAddress(String token, String id) async {
    final String query = '''
    mutation customerAddressDelete(\$id: ID!, \$customerAccessToken: String!) {
      customerAddressDelete(id: \$id, customerAccessToken: \$customerAccessToken) {
        customerUserErrors {
          code
          field
          message
        }
        deletedCustomerAddressId
      }
    }
  ''';

    try {
      final response = await _helper.post(
          headers: Request.headers,
          body: json.encode({
            'query': query,
            'variables': {
              "customerAccessToken": token,
              "id": id,
            }
          }));

      final List<CustomerUserError> errors = CustomerUserError.listFromJson(
          response['data']['customerAddressDelete']['customerUserErrors']);
      return errors.isEmpty ? '' : throw Exception();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
