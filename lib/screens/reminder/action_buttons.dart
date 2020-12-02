import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  bool reminderExists;
  Function insertOrReplaceReminder;
  Function deleteReminder;

  ActionButtons(
      this.reminderExists, this.insertOrReplaceReminder, this.deleteReminder);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          reminderExists ? DeleteButton(deleteReminder) : Text(""),
          CreateOrEditButton(insertOrReplaceReminder)
        ],
      ),
    );
  }
}

class CreateOrEditButton extends StatelessWidget {
  Function insertOrReplaceReminder;
  CreateOrEditButton(this.insertOrReplaceReminder);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await insertOrReplaceReminder();
        Navigator.pop(context);
      },
      tooltip: 'Create Reminder',
      child: Icon(Icons.check),
      heroTag: "createBtn",
    );
  }
}

class DeleteButton extends StatelessWidget {
  Function deleteReminder;
  DeleteButton(this.deleteReminder);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await deleteReminder();
        Navigator.pop(context);
      },
      child: Icon(Icons.delete),
      heroTag: "deleteBtn",
    );
  }
}
