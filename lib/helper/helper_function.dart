import 'package:flutter/material.dart';

// Display error to user
Future<void> displayMessageToUser(String message, BuildContext context) async {
  await showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      title: Text(
        message,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(
            'OK',
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary
            ),),
        ),
      ],
    ),
  );
}
