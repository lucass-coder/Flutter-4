import 'package:flutter/material.dart';

class TransactionAuthDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Autenticate'),
      content: TextField(
        obscureText: true,
        maxLength: 4,
        decoration: InputDecoration(
          border: OutlineInputBorder()
        ),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 64, letterSpacing: 32),
        keyboardType: TextInputType.number,
      ),
      actions: [
        // ignore: deprecated_member_use
        FlatButton(
          onPressed: () {},
          child: Text('Cancel'),
        ),
        FlatButton(
          onPressed: () {},
          child: Text('Confirm'),
        ),
      ],
    );
  }
}
