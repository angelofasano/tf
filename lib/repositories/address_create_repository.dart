import 'dart:convert';
import 'package:tf/models/customerUserError.dart';
import 'package:tf/utils/apiBaseHelper.dart';
import 'package:tf/utils/request.dart';

class AddressCreateRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<String> createAddress(String token, dynamic address) async {
    final String query = '''
    mutation customerAddressCreate(\$customerAccessToken: String!, \$address: MailingAddressInput!) {
      customerAddressCreate(
        customerAccessToken: \$customerAccessToken
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
              "address": address
            }
          }));

      final List<CustomerUserError> errors = CustomerUserError.listFromJson(
          response['data']['customerAddressCreate']['customerUserErrors']);
      return errors.isEmpty ? response['data']['customerAddressCreate']['customerAddress']['id'] : throw Exception();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
