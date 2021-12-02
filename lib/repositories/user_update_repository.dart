import 'dart:convert';
import 'package:tf/models/customerUserError.dart';
import 'package:tf/utils/apiBaseHelper.dart';
import 'package:tf/utils/request.dart';

class UserUpdateRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<UserUpdateResponse> updateUser(String token, dynamic user) async {
    final String query = '''
    mutation customerUpdate(\$customerAccessToken: String!, \$customer: CustomerUpdateInput!) {
      customerUpdate(customerAccessToken: \$customerAccessToken, customer: \$customer) {
        customer {
          id
        }
        customerAccessToken {
          accessToken
          expiresAt
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
            'variables': {"customerAccessToken": token, "customer": user}
          }));

      final List<CustomerUserError> errors = CustomerUserError.listFromJson(
          response['data']['customerUpdate']['customerUserErrors']);
      return errors.isEmpty ? UserUpdateResponse() : throw Exception();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

class UserUpdateResponse {}
