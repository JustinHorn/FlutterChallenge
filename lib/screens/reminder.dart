import 'package:ReminderApp/models/reminder.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:ReminderApp/cycle.dart';

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

  @override
  void initState() {
    super.initState();

    _cycle = Cycle.once;
    _message = "";
    time = DateTime.now();

    if (widget.reminder != null) {
      _message = widget.reminder.message;
      time = widget.reminder.getFirstDateTime();
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
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        icon: Icon(Icons.event),
                        dateLabelText: 'Date',
                        timeLabelText: "Hour",
                        selectableDayPredicate: (date) {
                          if (date.weekday == 6 || date.weekday == 7) {
                            return false;
                          }
                          return true;
                        },
                        onChanged: (val) => time = DateTime.parse(val),
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
          Navigator.pop(context);
        },
        tooltip: 'Create Reminder',
        child: Icon(Icons.check),
      ),
    );
  }
}
