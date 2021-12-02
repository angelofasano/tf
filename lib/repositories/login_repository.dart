import 'dart:convert';
import 'package:tf/models/customerUserError.dart';
import 'package:tf/utils/apiBaseHelper.dart';
import 'package:tf/utils/request.dart';

class LoginRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<bool> resetPassword(String email) async {
    final String query = '''
    mutation customerRecover(\$email: String!) {
      customerRecover(email: \$email) {
        customerUserErrors {
          code
          field
          message
        }
      }
    }
    ''';

    print(email);

    try {
      final response = await _helper.post(
          headers: Request.headers,
          body: json.encode({
            'query': query,
            'variables': {
              'email': email
            }
          }));

      print(response);

      final List<CustomerUserError> errors = CustomerUserError.listFromJson(
          response['data']['customerRecover']['customerUserErrors']);

      if (errors.isEmpty) {
        return true;
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<LoginResponse> login(String email, String password) async {
    final String query = '''
    mutation customerAccessTokenCreate(\$input: CustomerAccessTokenCreateInput!) {
      customerAccessTokenCreate(input: \$input) {
        customerUserErrors {
          code
          field
          message
        }
        customerAccessToken {
          accessToken
          expiresAt
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
              'input': {'email': email, 'password': password}
            }
          }));
      final dynamic token = response['data']?['customerAccessTokenCreate']
          ?['customerAccessToken']?['accessToken'];
      final List<CustomerUserError> errors = CustomerUserError.listFromJson(
          response['data']['customerAccessTokenCreate']['customerUserErrors']);

      return LoginResponse(errors, token ?? '');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

class LoginResponse {
  final List<CustomerUserError> errors;
  final String accessToken;
  LoginResponse(this.errors, this.accessToken);
}
