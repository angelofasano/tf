import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tf/components/backButton.dart';
import 'package:tf/components/loadDialog.dart';
import 'package:tf/repositories/signin_repository.dart';
import 'package:tf/screens/welcome_screen.dart';

class SigninScreen extends StatefulWidget {
  static String routeName = '/signin';

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  @override
  Widget build(BuildContext context) {
    return SigninForm();
  }
}

class SigninForm extends StatefulWidget {
  const SigninForm({Key? key}) : super(key: key);

  @override
  SigninFormState createState() {
    return SigninFormState();
  }
}

class SigninFormState extends State<SigninForm> {
  String email = '';
  String password = '';
  String firstName = '';
  String lastName = '';

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Form(
      key: _formKey,
      child: Scaffold(
        body: Container(
          height: height,
          width: width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      gradient: new LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).primaryColorLight,
                            Theme.of(context).primaryColorDark,
                          ]),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                    ),
                    width: width,
                    height: height * 0.4,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 16.0,
                      child: Lottie.asset('images/signin.json'),
                    ),
                  ),
                  Positioned(top: 40, left: 25, child: CustomBackButton())
                ]),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'SignIn',
                            style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),
                    _signInSpacer(),
                    TextFormField(
                      onSaved: (String? value) {
                        email = value!;
                      },
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Per favore inserisci una mail';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'Email',
                          suffixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                          labelText: 'E-mail'),
                    ),
                    _signInSpacer(),
                    TextFormField(
                        onSaved: (String? value) {
                          password = value!;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: Icon(Icons.password_outlined),
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Per favore inserisci una password';
                          }
                          return null;
                        }),
                    _signInSpacer(),
                    TextFormField(
                        onSaved: (String? value) {
                          firstName = value!;
                        },
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Nome',
                          border: OutlineInputBorder(),
                          labelText: 'Nome',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Per favore inserisci un nome';
                          }
                          return null;
                        }),
                    _signInSpacer(),
                    TextFormField(
                        onSaved: (String? value) {
                          lastName = value!;
                        },
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Cognome',
                          border: OutlineInputBorder(),
                          labelText: 'Cognome',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Per favore inserisci un cognome';
                          }
                          return null;
                        }),
                    _signInSpacer(),
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            child: Text('Registrati'),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ShowDialog.show(context);
                                _formKey.currentState!.save();
                                SigninRepository()
                                    .signin(
                                        email, password, firstName, lastName)
                                    .then((signinResponse) => {
                                          Navigator.pop(context),
                                          if (signinResponse.errors.isEmpty)
                                            Navigator.pushNamed(
                                              context,
                                              WelcomeScreen.routeName,
                                            )
                                          else
                                            {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Impossibile effettuare la registrazione')),
                                              )
                                            },
                                        })
                                    .catchError((onError) => {
                                          Navigator.pop(context),
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(content: Text(onError.toString())),
                                          )
                                        });
                              }
                            },
                          )
                        ])
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signInSpacer() {
    return SizedBox(height: 20.0);
  }
}
