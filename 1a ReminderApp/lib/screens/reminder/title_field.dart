import 'package:flutter/material.dart';

class TitleField extends StatelessWidget {
  String _message;
  Function setMessage;

  TitleField(this._message, this.setMessage);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: _message),
      decoration: InputDecoration(labelText: "Title"),
      onChanged: setMessage,
    );
  }
}
