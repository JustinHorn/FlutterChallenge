import 'package:ReminderApp/database_helper.dart';
import 'package:ReminderApp/screens/reminder/reminder.dart';
import 'package:flutter/material.dart';

import 'reminder_entry.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper databaseHelper = new DatabaseHelper();

  int id = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 0,
        ),
        child: FutureBuilder(
          initialData: [],
          future: databaseHelper.getReminders(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                if (index + 1 == snapshot.data.length) {
                  id = snapshot.data[index].id + 1;
                }
                return ReminderHomeEntry(
                  snapshot.data[index],
                  goToReminderPage,
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReminderPage(id: id),
          ),
        ).then((value) {
          setState(() {});
        }),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  void goToReminderPage(reminder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReminderPage(
          title: "Edit Reminder",
          reminder: reminder,
        ),
      ),
    ).then((v) {
      setState(() {});
    });
  }
}
