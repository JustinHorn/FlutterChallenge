import 'package:flutter/material.dart';

class MessageField extends StatelessWidget {
  String _message;
  Function setMessage;

  MessageField(this._message, this.setMessage);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: _message),
      decoration: InputDecoration(labelText: "Message"),
      onChanged: setMessage,
    );
  }
}
