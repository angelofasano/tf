import 'dart:convert';

import 'package:tf/utils/apiBaseHelper.dart';
import 'package:tf/utils/request.dart';

class LoginCheckRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<bool> checkIfUserIsLogged(String accessToken) async {
    String query = '''
      {
        customer(customerAccessToken:"$accessToken") 
          {
            id
          }
      }
    ''';
    final response = await _helper.post(
        headers: Request.headers, body: jsonEncode({'query': query}));

    final dynamic data = response['data'];
    final dynamic customer = data['customer'];
    return customer != null ? true : false;
  }
}
