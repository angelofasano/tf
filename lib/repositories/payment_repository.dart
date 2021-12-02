import 'dart:convert';
import 'package:tf/models/address.dart';
import 'package:tf/utils/apiBaseHelper.dart';
import 'package:tf/utils/request.dart';

class CreditCardVault {
  String number;
  String firstName;
  String lastName;
  int month;
  int year;
  int verificationValue;

  CreditCardVault(this.number, this.firstName, this.lastName, this.month,
      this.year, this.verificationValue);
}

class PaymentRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<void> completeCheckout(
    String checkoutID,
    Address address,
    String sessionID,
    double amount,
  ) async {
    final String query = '''
    mutation checkoutCompleteWithCreditCardV2(\$checkoutId: ID!, \$payment: CreditCardPaymentInputV2!) {
    checkoutCompleteWithCreditCardV2(checkoutId: \$checkoutId, payment: \$payment) {
        checkout {  
          id 
        }
        checkoutUserErrors {
          code
          field
          message
        }
        payment {
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
              "checkoutId": checkoutID,
              "payment": {
                "paymentAmount": {
                  "amount": amount.toString(),
                  "currencyCode": "EUR"
                },
                "idempotencyKey": "123",
                "billingAddress": address.toJson(),
                "vaultId": sessionID
              }
            }
          }));

      print(response);

      List<dynamic> errors = response['data']
          ['checkoutCompleteWithCreditCardV2']['checkoutUserErrors'];
      if (errors.isEmpty) {
        return;
      } else {
        throw Exception(errors.toString());
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<String> getPaymentSessionID(CreditCardVault vault) async {
    try {
      final response = await _helper.getPaymentID(
          headers: Request.headers,
          body: jsonEncode({
            'credit_card': {
              'number': vault.number.replaceAll(' ', ''),
              'first_name': vault.firstName,
              'last_name': vault.lastName,
              'month': vault.month,
              'year': vault.year,
              'verification_value': vault.verificationValue
            }
          }));

      if (response != null && response['id'] != null) {
        return response['id'];
      } else {
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
