import 'package:flutter/material.dart';
import 'package:tf/components/checkoutAddressCard.dart';
import 'package:tf/components/loadDialog.dart';
import 'package:tf/models/address.dart';
import 'package:tf/repositories/checkout_repository.dart';
import 'package:tf/repositories/user_repository.dart';
import 'package:tf/utils/provinces.dart';
import 'horizontalList.dart';

class AddressStep extends StatefulWidget {
  AddressStep(
      {this.user, required this.checkoutID, required this.successCallback});
  final UserResponse? user;
  final String checkoutID;
  final Function successCallback;
  @override
  State<AddressStep> createState() => _AddressStepState();
}

class _AddressStepState extends State<AddressStep> {
  GlobalKey _toolTipKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  String firstAddress = '';
  String civicNumber = '';
  String floor = '';
  String city = '';
  String company = '';
  String country = 'Italy';
  String firstName = '';
  String lastName = '';
  String phone = '';
  String zip = '';
  String province = '';

  TextEditingController firstAddressController = new TextEditingController();
  TextEditingController civicNumberController = new TextEditingController();
  TextEditingController floorController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController companyController = new TextEditingController();
  TextEditingController countryController =
      new TextEditingController(text: 'Italy');
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController zipController = new TextEditingController();
  TextEditingController provinceController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(children: [
            Column(children: [
              widget.user != null
                  ? ElevatedButton(
                      onPressed: () {
                        _showConfirmDialog(widget.user!);
                      },
                      child: Text('Scegli fra i tuoi indirizzi'))
                  : SizedBox.shrink(),
            ]),
            SizedBox(height: 20),
            _addressTextFields(),
            _floorTextField(),
            _cityTextField(),
            _companyTextField(),
            _countryTextField(),
            _fullNameTextField(),
            _phoneTextField(),
            _provinceAndZipTextField(),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ShowDialog.show(context);
                    CheckoutRepository()
                        .updateShippingAddress(
                            new Address(
                                address1: '$firstAddress, $civicNumber',
                                address2: '$floor',
                                city: '$city',
                                company: '$company',
                                country: '$country',
                                firstName: '$firstName',
                                lastName: '$lastName',
                                phone: '+39$phone',
                                province: '$province',
                                zip: '$zip'),
                            widget.checkoutID)
                        .then((response) => {
                          Navigator.of(context).pop(),
                          widget.successCallback(
                            new Address(
                                address1: '$firstAddress, $civicNumber',
                                address2: '$floor',
                                city: '$city',
                                company: '$company',
                                country: '$country',
                                firstName: '$firstName',
                                lastName: '$lastName',
                                phone: '+39$phone',
                                province: '$province',
                                zip: '$zip')
                          )
                        });
                  }
                },
                child: Text('Avanti'))
          ]),
        ));
  }

  setFormValues(Address address) {
    this.firstAddress = address.address1.split(',')[0];
    this.civicNumber = address.address1.split(',')[1].trim();
    this.floor = address.address2;
    this.city = address.city;
    this.company = address.company;
    this.country = address.country;
    this.firstName = address.firstName;
    this.lastName = address.lastName;
    this.phone = address.phone.substring(3, address.phone.length);
    this.zip = address.zip;
    this.province = address.province;

    this.firstAddressController.text = this.firstAddress;
    this.civicNumberController.text = this.civicNumber;
    this.floorController.text = this.floor;
    this.cityController.text = this.city;
    this.companyController.text = this.company;
    this.countryController.text = this.country;
    this.firstNameController.text = this.firstName;
    this.lastNameController.text = this.lastName;
    this.phoneController.text = this.phone;
    this.zipController.text = this.zip;
    this.provinceController.text = this.province;
  }

  _getDecoration(String label, String hint) {
    return new InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(),
      counterText: ' ',
      labelText: label,
    );
  }

  Widget _addressTextFields() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Flexible(
          flex: 6,
          child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: TextFormField(
                  controller: this.firstAddressController,
                  onChanged: (value) {
                    setState(() {
                      this.firstAddress = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                  decoration:
                      _getDecoration('Indirizzo', 'Via lago di como')))),
      Flexible(
          flex: 3,
          child: TextFormField(
              controller: this.civicNumberController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  this.civicNumber = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '';
                }
                return null;
              },
              decoration: _getDecoration('N.Civico', '10')))
    ]);
  }

  Widget _floorTextField() {
    return TextFormField(
      controller: this.floorController,
      onChanged: (String value) {
        setState(() {
          this.floor = value;
        });
      },
      keyboardType: TextInputType.streetAddress,
      decoration: _getDecoration('Scala / Interno', ''),
    );
  }

  Widget _cityTextField() {
    return TextFormField(
      controller: this.cityController,
      onChanged: (String value) {
        setState(() {
          this.city = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '';
        }
        return null;
      },
      keyboardType: TextInputType.streetAddress,
      decoration: _getDecoration('Citta', ''),
    );
  }

  Widget _companyTextField() {
    return TextFormField(
      controller: this.companyController,
      onChanged: (String value) {
        setState(() {
          this.company = value;
        });
      },
      keyboardType: TextInputType.streetAddress,
      decoration: _getDecoration('Azienda', ''),
    );
  }

  Widget _countryTextField() {
    return TextFormField(
      readOnly: true,
      controller: this.countryController,
      onChanged: (String value) {
        setState(() {
          this.country = value;
        });
      },
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
          hintText: '',
          suffixIcon: GestureDetector(
            onTap: () {
              final dynamic tooltip = _toolTipKey.currentState;
              tooltip.ensureTooltipVisible();
            },
            child: Tooltip(
              key: _toolTipKey,
              message: 'Al momento TF spedisce solo in Italia',
              child: Icon(Icons.info_outline),
            ),
          ),
          border: OutlineInputBorder(),
          counterText: ' ',
          labelText: 'Paese'),
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

  Widget _phoneTextField() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Padding(
          padding: EdgeInsets.only(right: 15, bottom: 25), child: Text('+39')),
      Flexible(
          child: TextFormField(
              controller: this.phoneController,
              keyboardType: TextInputType.number,
              maxLength: 10,
              onChanged: (value) {
                setState(() {
                  this.phone = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 10) {
                  return '';
                }
                return null;
              },
              decoration: _getDecoration('Telefono', '')))
    ]);
  }

  Widget _provinceAndZipTextField() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Flexible(
          flex: 5,
          child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: DropdownButtonFormField<String>(
                value: this.province != '' ? this.province : provinces[0],
                iconSize: 0,
                decoration: _getDecoration('Provincia', ''),
                style: TextStyle(color: Theme.of(context).primaryColor),
                onChanged: (String? newValue) {
                  setState(() {
                    this.province = newValue!;
                  });
                },
                items: provinces.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ))),
      Flexible(
          flex: 5,
          child: TextFormField(
              controller: this.zipController,
              keyboardType: TextInputType.number,
              maxLength: 5,
              onChanged: (value) {
                setState(() {
                  this.zip = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 5) {
                  return '';
                }
                return null;
              },
              decoration: _getDecoration('Codice postale', '')))
    ]);
  }

  _showConfirmDialog(UserResponse user) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Scegli indirizzo'),
          content: SingleChildScrollView(
            child: HorizontalList(
                elements: user.addresses
                    .map((addr) => CheckoutAddressCard(
                          address: addr,
                          isDefault: addr.id == user.defaultAddress.id,
                          successCallback: (Address address) => {
                            this.setState(() {
                              setFormValues(address);
                            }),
                            Navigator.pop(context)
                          },
                        ))
                    .toList()),
          ),
        );
      },
    );
  }
}
