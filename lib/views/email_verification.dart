import 'package:flutter/material.dart';
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/utilities/show_error_dialog.dart';
//import 'package:notesapp/utilities/show_logout_dialog.dart';
//import 'dart:developer' as devtools show log;

class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({super.key});

  @override
  State<EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView> {
  @override
  void initState() {
    super.initState();
    sendEmailVerification();
  }

  Future<void> sendEmailVerification() async {
    final user = AuthService.firebase().currentUser;
    if (user != null && !user.isEmailVerified) {
      await AuthService.firebase().sendEmailVerification();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email verification'),
      ),
      body: Column(
        children: [
          const Text('In order to complete the registration process, we need you to verify your email address. Please check your email inbox and spam folder and click on the link we sent you to finish your account verification and setup.'),
          ElevatedButton(
            onPressed: () async {
              await AuthService.firebase().currentUser?.reload(); 
              final user = AuthService.firebase().currentUser;
              if (user != null) {
                if (user.isEmailVerified) {
                  Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                } else {
                  showErrorDialog(context, 'Your email address has not been verified yet. Please, check your email inbox and spam folder and complete the process...', 'OK');
                }
              }
            },
            child: const Text('Done'),
          )
        ],
      ),
    );
  }
}
