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
        showAlertDialog(context);
      },
      child: Icon(Icons.delete),
      heroTag: "deleteBtn",
      backgroundColor: Colors.red,
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor,
        ),
        child: Text(
          "Cancel",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget deleteButton = FlatButton(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red,
        ),
        child: Text(
          "Delete",
          style: TextStyle(color: Colors.white, backgroundColor: Colors.red),
        ),
      ),
      onPressed: () async {
        await deleteReminder();
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Do you really want to delete this reminder?"),
      content: null,
      actions: [cancelButton, deleteButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
