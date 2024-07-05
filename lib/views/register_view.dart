import 'package:flutter/material.dart';
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/services/auth/auth_exceptions.dart';
import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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

  // This method builds the widget tree for the RegisterView widget.
  @override
  Widget build(BuildContext context) {
    // Create a Scaffold widget with an AppBar and a body.
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
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
                await AuthService.firebase().register(email: _email.text, password: _password.text);
                final user = AuthService.firebase().currentUser; 
                user?.reload();
                if (user != null) {
                  if (!user.isEmailVerified) {
                    Navigator.of(context).pushNamed(emailVerificationRoute);
                  }
                }
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(context, 'The email address you entered is already in use by another account...', 'OK');
              } on WeakPasswordAuthException {
                await showErrorDialog(context, 'The password you entered is too weak, please try again with a stronger one...', 'OK');
              } on InvalidEmailAuthException {
                await showErrorDialog(context, 'The email you entered is invalid and could not be recognized. Please, double check it and try again...', 'OK');
              } on UnknownAuthException {
                await showErrorDialog(context, 'An unknown error has occurred. Please, try again later...', 'OK');
              }
            },
            child: const Text('Register'),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('Already have an account? Login here!')),
        ],
      ),
    );
  }
}
