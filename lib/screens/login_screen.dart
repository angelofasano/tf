import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tf/components/loadDialog.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tf/redux/actions/setUserAccessToken.dart';
import 'package:tf/redux/appState.dart';
import 'package:tf/repositories/login_repository.dart';
import 'package:tf/screens/signin_screen.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = '/login';
  final Function reloadPage;

  LoginScreen({required this.reloadPage});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return LoginForm(reloadPage: widget.reloadPage);
  }
}

class LoginForm extends StatefulWidget {
  final Function reloadPage;

  LoginForm({required this.reloadPage});

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  String email = '';
  String password = '';

  String forgotPasswordEmail = '';
  TextEditingController forgotPasswordEmailController =
      new TextEditingController();

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
                _loginImage(width, height),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),
                    _loginSpacer(),
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
                    _loginSpacer(),
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
                    _loginSpacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                resetPasswordDialog();
                              },
                              child: Text(
                                'Hai dimenticato la password?',
                                style: TextStyle(fontSize: 12.0),
                              )),
                          StoreConnector<AppState, dynamic>(
                            converter: (store) => store,
                            builder: (_, store) => ElevatedButton(
                              child: Text('Login'),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  ShowDialog.show(context);
                                  _formKey.currentState!.save();
                                  executeLogin(context, store, email, password);
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    _loginSpacer(),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            SigninScreen.routeName,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Text('Non hai un account? ',
                                      style: TextStyle(fontSize: 12.0))),
                              Text('Registrati',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color:
                                          Theme.of(context).primaryColorDark)),
                            ],
                          ),
                        )),
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  resetPasswordDialog() {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text('Reset password'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                          'Verrà inviata una mail per una nuova password a questo indirizzo:'),
                      _loginSpacer(),
                      TextFormField(
                        controller: forgotPasswordEmailController,
                        onChanged: (String value) {
                          setState(() {
                            this.forgotPasswordEmail = value;
                          });
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            suffixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                            labelText: 'E-mail'),
                      ),
                      _loginSpacer(),
                      ElevatedButton(
                          onPressed: emailValid(this.forgotPasswordEmail)
                              ? () {
                                  Navigator.of(context).pop();
                                  ShowDialog.show(this.context);
                                  LoginRepository()
                                      .resetPassword(forgotPasswordEmail)
                                      .then((value) => {
                                            Navigator.of(this.context).pop(),
                                            ScaffoldMessenger.of(this.context)
                                                .showSnackBar(
                                              SnackBar(
                                                  backgroundColor:
                                                      Colors.lightGreen,
                                                  content: Text(
                                                      'Operazione eseguita con successo')),
                                            )
                                          })
                                      .catchError((onError) => {
                                            Navigator.of(this.context).pop(),
                                            ScaffoldMessenger.of(this.context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Impossibile resettare la password')),
                                            )
                                          });
                                }
                              : null,
                          child: Text('Conferma'))
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  bool emailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  Widget _loginSpacer() {
    return SizedBox(height: 20.0);
  }

  void executeLogin(context, store, email, password) {
    LoginRepository()
        .login(email, password)
        .then((loginResponse) => {
              Navigator.pop(context),
              if (loginResponse.accessToken != '')
                {
                  store.dispatch(SetUserAccessTokenAction(
                      token: loginResponse.accessToken)),
                  widget.reloadPage(loginResponse.accessToken)
                },
              if (loginResponse.errors.isNotEmpty)
                {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Utente non identificato')),
                  )
                },
            })
        .catchError((onError) => {
              {
                Navigator.pop(context),
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(onError.toString())),
                )
              },
            });
  }

  Widget _loginImage(width, height) {
    return Container(
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
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      width: width,
      height: height * 0.45,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 16.0,
        child: Lottie.asset('images/login.json'),
      ),
    );
  }
}
