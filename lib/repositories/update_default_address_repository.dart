import 'dart:convert';
import 'package:tf/models/customerUserError.dart';
import 'package:tf/utils/apiBaseHelper.dart';
import 'package:tf/utils/request.dart';

class UpdateDefaultAddressRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<UpdateDefaultAddressResponse> updateDefaultAddress(String token, String id) async {
    final String query = '''
    mutation customerDefaultAddressUpdate(\$customerAccessToken: String!, \$addressId: ID!) {
      customerDefaultAddressUpdate(
        customerAccessToken: \$customerAccessToken
        addressId: \$addressId
      ) {
        customer {
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
              "addressId": id,
            }
          }));

      final List<CustomerUserError> errors = CustomerUserError.listFromJson(
          response['data']['customerDefaultAddressUpdate']['customerUserErrors']);
      return errors.isEmpty ? UpdateDefaultAddressResponse() : throw Exception();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

class UpdateDefaultAddressResponse {}
