import 'package:flutter/material.dart';
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/utilities/show_logout_dialog.dart';

enum MenuAction {
  logout,
}
class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}
class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your notes'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              if (value == MenuAction.logout) {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogoutDialog(context);
                    if (shouldLogout) {
                      await AuthService.firebase().logOut();
                      if (AuthService.firebase().currentUser == null) {
                        Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                      }
                    }

                    break;
                }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'), 
                ),
              ];
            },
          )
        ],
      ),
      body: const Text('Hello, world!'),
    );
  }
}
