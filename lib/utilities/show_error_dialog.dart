import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String mainText, String btnText) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Oops! An error occurred'),
        content: Text(mainText),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(btnText),
          ),
        ],
      );
    }
  );
}