import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/firebase_options.dart';

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
                final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email.text, password: _password.text);
                print(userCredential);
              } on FirebaseAuthException catch (e) {
                print('Failed with error code: ${e.code}');
                print(e.message);
              }
            },
            child: const Text('Register'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);
            },
            child: const Text('Already have an account? Login here!')),
        ],
      ),
    );
  }
}
