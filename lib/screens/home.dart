import 'package:ReminderApp/models/reminder.dart';
import 'package:ReminderApp/screens/reminder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:ReminderApp/cycle.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        child: ListView(
          children: [
            ...List<Widget>.generate(
              10,
              (i) => ReminderHomeEntry(
                Reminder(
                  i,
                  "Example Message",
                  Cycle.once,
                  "Monday 01.12.2020",
                  "17:00",
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReminderPage(),
          ),
        ),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class ReminderHomeEntry extends StatelessWidget {
  Reminder reminder;

  ReminderHomeEntry(this.reminder);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("hi");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReminderPage(
              title: "Edit Reminder",
              reminder: reminder,
            ),
          ),
        );
      },
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
                .toList()
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
      "First: " + reminder.firstDate,
      "ID: " + reminder.id.toString()
    ];
  }
}
