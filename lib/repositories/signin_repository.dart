import 'dart:convert';
import 'package:tf/models/customerUserError.dart';
import 'package:tf/utils/apiBaseHelper.dart';
import 'package:tf/utils/request.dart';

class SigninRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<SigninResponse> signin(
      String email, String password, String firstName, String lastName) async {
    final String query = '''
    mutation customerCreate(\$input: CustomerCreateInput!) {
        customerCreate(input: \$input) {
          customerUserErrors {
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
          body: json.encode({
            'query': query,
            'variables': {
              'input': {
                'email': email,
                'password': password,
                'firstName': firstName,
                'lastName': lastName
              }
            }
          }));
      print(response);
      final List<CustomerUserError> errors = CustomerUserError.listFromJson(
          response['data']['customerCreate']['customerUserErrors']);

      return SigninResponse(errors: errors);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

class SigninResponse {
  final List<CustomerUserError> errors;

  SigninResponse({required this.errors});
}
