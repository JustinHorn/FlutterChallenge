import 'package:ReminderApp/models/reminder.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:ReminderApp/cycle.dart';
import 'dart:math';

class ReminderPage extends StatefulWidget {
  ReminderPage({
    Key key,
    this.title = "Create Reminder",
    this.reminder = null,
  }) : super(key: key);

  final String title;
  final Reminder reminder;

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  String _message;
  DateTime time;
  Cycle _cycle;

  DateTime minimumTime;
  DateTime maximumTime;

  @override
  void initState() {
    super.initState();

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
      print(minimumTime.toString());
      _cycle = widget.reminder.cycle;
    }
  }

  void logData() {
    print(_message);
    print(time);
    print(_cycle.name);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          logData();
          widget.reminder.getFirstDateTime();
          //Navigator.pop(context);
        },
        tooltip: 'Create Reminder',
        child: Icon(Icons.check),
      ),
    );
  }
}
