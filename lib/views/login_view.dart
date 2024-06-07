import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:notes/constants/routes.dart';
import 'package:notes/utilities/show_error_dialog.dart';

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
                  var user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    await FirebaseAuth.instance.signOut();
                  }
                  await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email.text, password: _password.text);
                  user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    if (user.emailVerified) {
                      Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                    } else {
                      Navigator.of(context).pushNamed(emailVerificationRoute);
                    }
                  }
                } else {
                  showErrorDialog(context, 'Please, make sure to correctly fill both email and password fields...', 'OK');
                }

              } on FirebaseAuthException catch (e) {
                if (e.code == 'invalid-email') {
                  showErrorDialog(context, 'The email you entered is invalid and could not be recognized. Please, double check it and try again...', 'OK');
                } else if (e.code == 'invalid-credential') {
                  showErrorDialog(context, 'Please, check your email and password or try again later...', 'OK');
                } /* else if (e.code == 'user-not-found') {
                  // ONLY WORKS IF "EMAIL ENUMERATION" IS ENABLED FROM FIREBASE AUTHENTICATION SETTINGS
                  showErrorDialog(context, 'No registered account founded. Please, check your email address...', 'OK');
                } else if (e.code == 'wrong-password') {
                  // ONLY WORKS IF "EMAIL ENUMERATION" IS ENABLED FROM FIREBASE AUTHENTICATION SETTINGS
                  showErrorDialog(context, 'The password you entered is incorrect. Please, double check it and try again...', 'OK');
                } */
                else {
                  showErrorDialog(context, 'Please, check your email and password or try again later...', 'OK');
                }

                devtools.log(e.code);
              } catch (e) {
                showErrorDialog(context, 'An unknown error has occurred. Please, try again later...', 'OK');
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
