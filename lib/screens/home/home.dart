import 'package:ReminderApp/database_helper.dart';
import 'package:ReminderApp/models/reminder.dart';
import 'package:ReminderApp/reminder_bloc.dart';
import 'package:ReminderApp/screens/reminder/reminder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ReminderApp/main.dart';

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
  void initState() {
    super.initState();
    databaseHelper.getReminders().then((reminders) {
      ReminderAction rA = new ReminderAction(
        ReminderActionType.addAll,
        reminders: reminders,
      );
      context.read<ReminderBloc>().add(rA);
    });
  }

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
        child: BlocBuilder<ReminderBloc, List<Reminder>>(
          builder: (_, reminder) {
            return ListView.builder(
              itemCount: reminder.length,
              itemBuilder: (context, index) {
                if (index + 1 == reminder.length) {
                  id = reminder[index].id + 1;
                }
                return ReminderHomeEntry(
                  reminder[index],
                  goToReminderPage,
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ReminderPage(id: id),
          ),
        ),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  void goToReminderPage(reminder) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReminderPage(
          title: "Edit Reminder",
          reminder: reminder,
        ),
      ),
    );
  }
}
