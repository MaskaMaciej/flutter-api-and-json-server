import 'package:flutter/material.dart';

class CustomDialogAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure you want to delete this user?'),
      actions: [
        ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false);
            }),
        ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            ),
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(true);
            }),
      ],
    );
  }
}
