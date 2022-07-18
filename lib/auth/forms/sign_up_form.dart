import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SignUpForm extends StatefulWidget {
  final Function submitCallback;

  SignUpForm(this.submitCallback);

  @override
  State<StatefulWidget> createState() {
    return _SignUpFormState();
  }
}

class _SignUpFormState extends State<SignUpForm> {
  var email;
  var username;
  var password;

  bool isPasswordShown = false;

  var isReqError = false;
  var reqErrorMessage;
  var reqErrorCode;

  var favoriteFranchiseIndex = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(children: [
        Container(
          margin: EdgeInsets.only(left: 20, top: 80),
          alignment: Alignment.topLeft,
          child: const Text("Create an account",
              style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  height: 1,
                  fontWeight: FontWeight.bold)),
        ),
        Column(
          children: [
            Container(
                margin: const EdgeInsets.only(
                    top: 100, bottom: 10, left: 20, right: 20),
                child: TextFormField(
                    decoration: InputDecoration(
                        labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary),
                        label: Text("Email"),
                        icon: Icon(
                          Icons.email_rounded,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.tertiary),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        contentPadding: EdgeInsets.only(left: 12)),
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                    obscureText: false,
                    enableSuggestions: true,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Email';
                      } else if (!value.contains('@')) {
                        return 'Invalid Email address';
                      } else if (isReqError && reqErrorCode == 0) {
                        return reqErrorMessage;
                      }

                      return null;
                    },
                    onChanged: (value) {
                      isReqError = false;
                      email = value;
                    })),
            Container(
                margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: TextFormField(
                    decoration: InputDecoration(
                        labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary),
                        label: Text("Username"),
                        icon: Icon(
                          Icons.account_circle_rounded,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.tertiary),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        contentPadding: EdgeInsets.only(left: 12)),
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                    obscureText: false,
                    enableSuggestions: true,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      } else if (isReqError && reqErrorCode == 1) {
                        return reqErrorMessage;
                      }

                      return null;
                    },
                    onChanged: (value) {
                      isReqError = false;
                      username = value;
                    })),
            Container(
                margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: TextFormField(
                    decoration: InputDecoration(
                        labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary),
                        label: Text("Password"),
                        icon: Icon(
                          Icons.lock_rounded,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: (() => setState(() {
                                isPasswordShown = !isPasswordShown;
                              })),
                          child: isPasswordShown
                              ? Icon(
                                  Ionicons.eye,
                                  color: Colors.white,
                                )
                              : Icon(
                                  Ionicons.eye_off,
                                  color: Colors.white,
                                ),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.tertiary),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        contentPadding: EdgeInsets.only(left: 12)),
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                    obscureText: !isPasswordShown,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      } else if (value.length < 8) {
                        return 'Your password must be 8 characters long or more';
                      } else if (!value.contains(RegExp(r'[A-Z]'))) {
                        return 'Your password must contain an uppercase';
                      } else if (!value.contains(RegExp(r'[0-9]'))) {
                        return 'Your password must contain a number';
                      }

                      return null;
                    },
                    onChanged: (value) {
                      password = value;
                    })),
            /*Container(
              margin: EdgeInsets.only(top: 30, bottom: 5),
              alignment: Alignment.center,
              child: Text(
                'Select your favorite NBA team :',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            Container(
              height: 70,
              width: 400,
              alignment: Alignment.center,
              padding: EdgeInsets.zero,
              margin: const EdgeInsets.only(bottom: 10, left: 40, right: 40),
              child: FranchiseDropdown(),
            )*/
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 40),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: Offset(0, 4),
                    blurRadius: 6)
              ]),
          child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final exception = await widget.submitCallback(
                      email, username, password, context);

                  if (exception != null) {
                    final error = jsonDecode(exception.errorMessage);
                    setState(() {
                      isReqError = true;

                      reqErrorCode = int.parse(error['error']);
                      reqErrorMessage = error['message'];
                    });

                    _formKey.currentState!.validate();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
              ),
              child: Text(
                'Sign up',
                style: TextStyle(fontSize: 18),
              )),
        ),
      ]),
    );
  }
}
