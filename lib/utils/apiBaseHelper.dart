import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'appException.dart';

class ApiBaseHelper {
  final String _baseUrl =
      "MY_BASE_URL";

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await http.get(Uri.parse(url));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post({Map<String, String> headers = const {}, body = const {}}) async {
    var responseJson;
    try {
      final response = await http.post(Uri.parse(_baseUrl), headers: headers, body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getPaymentID({Map<String, String> headers = const {}, body = const {}}) async {
    var responseJson;
    try {
      final response = await http.post(Uri.parse('https://elb.deposit.shopifycs.com/sessions'), headers: headers, body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> createPayment(String token, {Map<String, String> headers = const {}, body = const {}}) async {
    var responseJson;
    try {
      final response = await http.post(Uri.parse('MY_PAYMENT_URI'), headers: headers, body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
