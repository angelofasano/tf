import 'package:flutter/material.dart';
import 'package:tf/components/backButton.dart';
import 'package:tf/components/header.dart';
import 'package:tf/components/loadDialog.dart';
import 'package:tf/repositories/user_update_repository.dart';
import 'package:tf/utils/checkboxColor.dart';
import 'package:tf/utils/userUpdateArguments.dart';
import 'package:flutter/cupertino.dart';

class UserUpdateScreen extends StatefulWidget {
  static String routeName = '/userUpdate';
  @override
  State<UserUpdateScreen> createState() => _UserUpdateScreenState();
}

class _UserUpdateScreenState extends State<UserUpdateScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as UserUpdateArguments;
    return UserUpdateForm(args.token, args.successCallback,
        args.acceptsMarketing, args.email, args.phone);
  }
}

class UserUpdateForm extends StatefulWidget {
  @override
  State<UserUpdateForm> createState() => _UserUpdateFormState();

  UserUpdateForm(this.token, this.successCallback, this.acceptsMarketing,
      this.email, this.phone);
  final String token;
  final Function successCallback;
  final bool? acceptsMarketing;
  final String? email;
  final String? phone;
}

class _UserUpdateFormState extends State<UserUpdateForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.email != '') {
      this.email = widget.email!;
      this.emailController = new TextEditingController(text: this.email);
    }
    if (widget.phone != '') {
      this.phone = widget.phone!.substring(3, widget.phone!.length);
      this.phoneController = new TextEditingController(text: this.phone);
    }
    if (widget.acceptsMarketing!) {
      this.acceptsMarketing = widget.acceptsMarketing!;
    }
  }

  String phone = '';
  String email = '';
  bool acceptsMarketing = false;
  
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
                SizedBox(
                  height: 20.0,
                ),
                _mailTextField(),
                _phoneTextField(),
                _acceptsMarketingCheckbox(),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ShowDialog.show(context);
                      UserUpdateRepository()
                          .updateUser(widget.token, {
                            'phone': '+39$phone',
                            'email': '$email',
                            'acceptsMarketing': acceptsMarketing
                          })
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
                                          Text('Uno dei campi non è valido')),
                                )
                              });
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

  Widget _mailTextField() {
    return TextFormField(
      controller: this.emailController,
      onChanged: (String value) {
        setState(() {
          this.email = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty || !isMailValid(email)) {
          return '';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          hintText: '',
          border: OutlineInputBorder(),
          counterText: ' ',
          labelText: 'Email'),
    );
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
              decoration: InputDecoration(
                hintText: '',
                suffixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
                counterText: ' ',
                labelText: 'Telefono',
              )))
    ]);
  }

  Widget _acceptsMarketingCheckbox() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Flexible(
          flex: 7,
          child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Header(label: 'Accetta marketing'))),
      Flexible(
          flex: 3,
          child: Checkbox(
            checkColor: Colors.white,
            fillColor: MaterialStateProperty.resolveWith(CheckBoxColor.getColor),
            value: this.acceptsMarketing,
            onChanged: (bool? value) {
              setState(() {
                acceptsMarketing = value!;
              });
            },
          ))
    ]);
  }

  bool isMailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
}
