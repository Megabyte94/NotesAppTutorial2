import 'package:flutter/material.dart';
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/views/email_verification.dart';
import 'package:notesapp/views/login_view.dart';
import 'package:notesapp/views/notes_view.dart';
import 'package:notesapp/views/register_view.dart';

// App entry point
void main() {
  // Ensure that the Flutter bindings are initialized.
  WidgetsFlutterBinding.ensureInitialized();
  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const InitialView(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        emailVerificationRoute: (context) => const EmailVerificationView(),
        notesRoute: (context) => const NotesView(),
      },
    );
  }
}

//2--------------------

// Initial view
class InitialView extends StatelessWidget {
  const InitialView({super.key});

  // This method builds the widget tree for the InitialView widget.
  @override
  Widget build(BuildContext context) {
    // Create a Scaffold widget with an AppBar and a body.
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            var user = AuthService.firebase().currentUser;
            user?.reload();
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView(); 
              } else {
                // Log the user out if their email is not verified, and redirect them to the login page.
                AuthService.firebase().logOut();
                return const LoginView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

//1----------
// NotesView


