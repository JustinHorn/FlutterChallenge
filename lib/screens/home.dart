import 'package:ReminderApp/database_helper.dart';
import 'package:ReminderApp/models/reminder.dart';
import 'package:ReminderApp/screens/reminder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:ReminderApp/cycle.dart';
import 'package:sqflite/sqflite.dart';

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
                return ReminderHomeEntry(snapshot.data[index], getOnTap());
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

  Function getOnTap() {
    return (reminder) {
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
        print("setState executed!");
      });
    };
  }
}

class ReminderHomeEntry extends StatelessWidget {
  Reminder reminder;
  Function onTap;

  ReminderHomeEntry(this.reminder, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(reminder),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '"${reminder.message}"',
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
            ...getReminderDataAsList()
                .map(
                  (stringData) => Text(
                    stringData,
                    style: Theme.of(context).primaryTextTheme.bodyText1,
                  ),
                )
                .toList(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'First: ${reminder.firstDate}',
                    style: Theme.of(context).primaryTextTheme.bodyText1,
                  ),
                ),
                Text(
                  reminder.id.toString(),
                  style: Theme.of(context).primaryTextTheme.bodyText1,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  List<String> getReminderDataAsList() {
    return [
      "Cycle: " + reminder.cycle.name,
      "Time: " + reminder.time,
      "Next: " + reminder.calcNextDate(),
    ];
  }
}
