import 'package:flutter/material.dart';
import 'package:tf/components/backButton.dart';
import 'package:tf/components/header.dart';
import 'package:tf/components/loadDialog.dart';
import 'package:tf/repositories/address_create_repository.dart';
import 'package:tf/repositories/update_default_address_repository.dart';
import 'package:tf/utils/addressCreateArguments.dart';
import 'package:tf/utils/checkboxColor.dart';
import 'package:tf/utils/provinces.dart';

class AddressCreateScreen extends StatefulWidget {
  static String routeName = '/addressCreate';
  @override
  State<AddressCreateScreen> createState() => _AddressCreateScreenState();
}

class _AddressCreateScreenState extends State<AddressCreateScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as AddressCreateArguments;
    return AddressCreateForm(args.token, args.successCallback);
  }
}

class AddressCreateForm extends StatefulWidget {
  @override
  State<AddressCreateForm> createState() => _AddressCreateFormState();

  AddressCreateForm(this.token, this.successCallback);
  final String token;
  final Function successCallback;
}

class _AddressCreateFormState extends State<AddressCreateForm> {
  GlobalKey _toolTipKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // SET DATA
    this.country = 'Italy';
    this.province = provinces[0];

    // SET CONTROLLERS
    this.firstAddressController =
        new TextEditingController(text: this.firstAddress);
    this.civicNumberController =
        new TextEditingController(text: this.civicNumber);
    this.floorController = new TextEditingController(text: this.floor);
    this.cityController = new TextEditingController(text: this.city);
    this.companyController = new TextEditingController(text: this.company);
    this.countryController = new TextEditingController(text: 'Italy');
    this.firstNameController = new TextEditingController(text: this.firstName);
    this.lastNameController = new TextEditingController(text: this.lastName);
    this.phoneController = new TextEditingController(text: this.phone);
    this.zipController = new TextEditingController(text: this.zip);
    this.provinceController = new TextEditingController(text: this.province);
  }

  String firstAddress = '';
  String civicNumber = '';
  String floor = '';
  String city = '';
  String company = '';
  String country = '';
  String firstName = '';
  String lastName = '';
  String phone = '';
  String zip = '';
  String province = '';
  bool isDefault = false;

  TextEditingController firstAddressController = new TextEditingController();
  TextEditingController civicNumberController = new TextEditingController();
  TextEditingController floorController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController companyController = new TextEditingController();
  TextEditingController countryController = new TextEditingController();
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController zipController = new TextEditingController();
  TextEditingController provinceController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
          body: SafeArea(
              child: SingleChildScrollView(
                  child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomBackButton(),
                Spacer(),
                _addressTextFields(),
                _floorTextField(),
                _cityTextField(),
                _companyTextField(),
                _countryTextField(),
                _fullNameTextField(),
                _phoneTextField(),
                _provinceAndZipTextField(),
                _favouriteCheckbox(),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ShowDialog.show(context);

                      if (!this.isDefault) {
                        AddressCreateRepository().createAddress(widget.token, {
                          'address1': '$firstAddress, $civicNumber',
                          'address2': '$floor',
                          'city': '$city',
                          'company': '$company',
                          'country': '$country',
                          'firstName': '$firstName',
                          'lastName': '$lastName',
                          'phone': '+39$phone',
                          'province': '$province',
                          'zip': '$zip'
                        })
                            .then((_) => {
                                  Navigator.of(context).pop(),
                                  Navigator.of(context).pop(),
                                  widget.successCallback()
                                })
                            .catchError((onError) => {
                                  Navigator.of(context).pop(),
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Si e verificato un errore')),
                                  )
                                });
                      } else {
                        AddressCreateRepository().createAddress(widget.token, {
                          'address1': '$firstAddress, $civicNumber',
                          'address2': '$floor',
                          'city': '$city',
                          'company': '$company',
                          'country': '$country',
                          'firstName': '$firstName',
                          'lastName': '$lastName',
                          'phone': '+39$phone',
                          'province': '$province',
                          'zip': '$zip'
                        }).then((newAddressID) => UpdateDefaultAddressRepository().updateDefaultAddress(
                                widget.token, newAddressID)
                            .then((value) => {
                                  Navigator.of(context).pop(),
                                  Navigator.of(context).pop(),
                                  widget.successCallback()
                                })
                            .catchError((onError) => {
                                  Navigator.of(context).pop(),
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Si e verificato un errore')),
                                  )
                                }));
                      }
                    }
                  },
                  child: Text('Salva'),
                  style: ElevatedButton.styleFrom(fixedSize: Size(240, 50)),
                )
              ],
            ),
          ))),
        ));
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

  Widget _favouriteCheckbox() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Flexible(
          flex: 7,
          child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Header(label: 'Imposta come preferito'))),
      Flexible(
          flex: 3,
          child: Checkbox(
            checkColor: Colors.white,
            fillColor:
                MaterialStateProperty.resolveWith(CheckBoxColor.getColor),
            value: this.isDefault,
            onChanged: (bool? value) {
              setState(() {
                isDefault = value!;
              });
            },
          ))
    ]);
  }
}

class Spacer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.0,
    );
  }
}
