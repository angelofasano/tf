import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tf/models/address.dart';
import 'package:tf/repositories/payment_repository.dart';

import 'loadDialog.dart';

class PaymentStep extends StatefulWidget {
  PaymentStep({required this.checkoutID, required this.selectedBillingAddress});
  final Address selectedBillingAddress;
  final String checkoutID;
  @override
  State<PaymentStep> createState() => _PaymentStepState();
}

class _PaymentStepState extends State<PaymentStep> {
  String number = '';
  String firstName = '';
  String lastName = '';
  int month = DateTime.now().month;
  int year = DateTime.now().year;
  int verificationValue = 123;

  TextEditingController numberController = new TextEditingController();
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController monthController = new TextEditingController();
  TextEditingController yearController = new TextEditingController();
  TextEditingController verificationValueController =
      new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(children: [
          _cartNumberTextField(),
          _fullNameTextField(),
          _monthTextField(),
          _yearTextField(),
          _verificationValueTextField(),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ShowDialog.show(context);
                  PaymentRepository()
                      .getPaymentSessionID(CreditCardVault(number.trim(),
                          firstName, lastName, month, year, verificationValue))
                      .then((String id) => PaymentRepository().completeCheckout(
                          widget.checkoutID, widget.selectedBillingAddress, id, 100.00))
                      .then((_) => {Navigator.of(context).pop()})
                      .catchError((onError) => {Navigator.of(context).pop()});
                }
              },
              child: Text('Avanti'))
        ])));
  }

  Widget _verificationValueTextField() {
    return TextFormField(
      controller: this.verificationValueController,
      onChanged: (String value) {
        setState(() {
          this.verificationValue = int.parse(value);
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '';
        }
        return null;
      },
      maxLength: 3,
      keyboardType: TextInputType.number,
      decoration: _getDecoration('Codice verifica', ''),
    );
  }

  Widget _yearTextField() {
    return TextFormField(
      controller: this.yearController,
      onChanged: (String value) {
        setState(() {
          this.year = int.parse(value);
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '';
        }
        return null;
      },
      maxLength: 2,
      keyboardType: TextInputType.number,
      decoration: _getDecoration('Anno', ''),
    );
  }

  Widget _monthTextField() {
    return TextFormField(
      controller: this.monthController,
      onChanged: (String value) {
        setState(() {
          this.month = int.parse(value);
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '';
        }
        return null;
      },
      maxLength: 2,
      keyboardType: TextInputType.number,
      decoration: _getDecoration('Mese', ''),
    );
  }

  Widget _cartNumberTextField() {
    return TextFormField(
      inputFormatters: [
        new CardNumberInputFormatter(),
        WhitelistingTextInputFormatter.digitsOnly,
        new LengthLimitingTextInputFormatter(19),
        new CardNumberInputFormatter()
      ],
      controller: this.numberController,
      onChanged: (String value) {
        setState(() {
          this.number = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '';
        }
        return null;
      },
      keyboardType: TextInputType.number,
      decoration: _getDecoration('Numero carta', ''),
    );
  }

  Widget _fullNameTextField() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Flexible(
          flex: 5,
          child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: TextFormField(
                  controller: this.firstNameController,
                  onChanged: (value) {
                    setState(() {
                      this.firstName = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                  decoration: _getDecoration('Nome', '')))),
      Flexible(
          flex: 5,
          child: TextFormField(
              controller: this.lastNameController,
              onChanged: (value) {
                setState(() {
                  this.lastName = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '';
                }
                return null;
              },
              decoration: _getDecoration('Cognome', '')))
    ]);
  }

  _getDecoration(String label, String hint) {
    return new InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(),
      counterText: ' ',
      labelText: label,
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write('  '); // Add double spaces.
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }
}
