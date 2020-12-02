import 'package:ReminderApp/database_helper.dart';
import 'package:ReminderApp/models/reminder.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:ReminderApp/cycle.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class ReminderPage extends StatefulWidget {
  ReminderPage({
    Key key,
    this.title = "Create Reminder",
    this.reminder,
    this.id,
  }) : super(key: key);

  final String title;
  final Reminder reminder;
  final int id;

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  String _message;
  DateTime time;
  Cycle _cycle;

  DateTime minimumTime;
  DateTime maximumTime;

  @override
  void initState() {
    super.initState();

    if (widget.reminder == null && widget.id == null) {
      throw new Exception("Either widget or id needs to be defined!");
    }

    _cycle = Cycle.once;
    _message = "";
    time = DateTime.now();
    minimumTime = time;
    maximumTime = DateTime(2100);

    if (widget.reminder != null) {
      _message = widget.reminder.message;
      time = widget.reminder.getFirstDateTime();
      if (time.millisecondsSinceEpoch < minimumTime.millisecondsSinceEpoch) {
        minimumTime = DateTime.fromMillisecondsSinceEpoch(
            time.millisecondsSinceEpoch - 1);
        maximumTime = DateTime.fromMillisecondsSinceEpoch(
            time.millisecondsSinceEpoch + 1);
      }
      _cycle = widget.reminder.cycle;
    }
  }

  String getDate() {
    return DateFormat("EEEE dd.MM.yyyy").format(time);
  }

  String getTime() {
    return DateFormat("HH:mm").format(time);
  }

  void logData() {
    print(_message);
    print(getDate());
    print(getTime());
    print(_cycle.name);
    print(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: TextEditingController(text: _message),
                  decoration: InputDecoration(labelText: "Message"),
                  onChanged: (value) => _message = value,
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Start Time:"),
                      DateTimePicker(
                        type: DateTimePickerType.dateTimeSeparate,
                        dateMask: 'EEEE d MMM, yyyy',
                        initialValue: time.toString(),
                        firstDate: minimumTime,
                        lastDate: maximumTime,
                        icon: Icon(Icons.event),
                        dateLabelText: 'Date',
                        timeLabelText: "Hour",
                        onChanged: (val) {
                          time = DateTime.parse(val);
                          print(time.toString());
                        },
                      ),
                      ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: Cycle.values
                              .map(
                                (cycle) => RaisedButton(
                                  padding: const EdgeInsets.all(0.0),
                                  onPressed: () {
                                    setState(() {
                                      _cycle = cycle;
                                    });
                                  },
                                  color: cycle == _cycle ? Colors.blue : null,
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    child: Text(cycle.name),
                                  ),
                                ),
                              )
                              .toList())
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (widget.reminder != null)
              FloatingActionButton(
                onPressed: () async {
                  await databaseHelper.deleteReminder(getId());
                  print("Reminder was deleted!");
                  Navigator.pop(context);
                },
                child: Icon(Icons.delete),
                heroTag: "btn1",
              )
            else
              Text(""),
            FloatingActionButton(
              onPressed: () async {
                logData();
                Reminder reminder = Reminder(
                  getId(),
                  _message,
                  _cycle,
                  getDate(),
                  getTime(),
                );

                await databaseHelper.insertReminder(reminder);
                print("reminder inserted or replaced!");
                Navigator.pop(context);
              },
              tooltip: 'Create Reminder',
              child: Icon(Icons.check),
              heroTag: "btn2",
            ),
          ],
        ),
      ),
    );
  }

  int getId() {
    if (widget.reminder != null) {
      return widget.reminder.id;
    } else {
      return widget.id;
    }
  }
}
