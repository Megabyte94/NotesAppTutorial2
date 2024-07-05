import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/services/auth/auth_exceptions.dart';
import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Initialize text editing controllers
  late final TextEditingController _email;
  late final TextEditingController _password;

  // It creates instances of TextEditingController and assigns them to the _email and _password variables.
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  /* This code disposes the text editing controllers when the widget is removed from the widget tree.
  It calls the dispose() method on the _email and _password controllers to release any resources they hold.*/
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  // This method builds the widget tree for the LoginView widget.
  @override
  Widget build(BuildContext context) {
    // Create a Scaffold widget with an AppBar and a body.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _password,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
                  var user = AuthService.firebase().currentUser;
                  if (user != null) {
                    await AuthService.firebase().logOut(); 
                  }
                  await AuthService.firebase().login(email: _email.text, password: _password.text);
                  user = AuthService.firebase().currentUser;
                  if (user != null) {
                    if (user.isEmailVerified) {
                      Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                    } else {
                      Navigator.of(context).pushNamed(emailVerificationRoute);
                    }
                  }
                } else {
                  showErrorDialog(context, 'Please, make sure to correctly fill both email and password fields...', 'OK');
                }

              } on InvalidEmailAuthException {
                await showErrorDialog(context, 'The email you entered is invalid and could not be recognized. Please, double check it and try again...', 'OK');
              } on InvalidCredentialAuthException {
                await showErrorDialog(context, 'Please, check your email and password or try again later...', 'OK');
              } /*on UserNotFoundAuthException { // ONLY WORKS IF EMAIL ENUMERATION IS ENABLED IN FIREBASE
                await showErrorDialog(context, 'No registered account founded. Please, check your email address...', 'OK');
              } on WrongPasswordAuthException { // ONLY WORKS IF EMAIL ENUMERATION IS ENABLED IN FIREBASE
                await showErrorDialog(context, 'The password you entered is incorrect. Please, double check it and try again...', 'OK');
              }*/ on UnknownAuthException {
                await showErrorDialog(context, 'An unknown error has occurred. Please, try again later...', 'OK');
              }
            },
            child: const Text('Login'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Not registered yet? Register here!'),
          ),
        ],
      ),
    );
  }
}
