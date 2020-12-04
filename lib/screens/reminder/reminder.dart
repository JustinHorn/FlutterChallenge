import 'package:ReminderApp/models/reminder.dart';
import 'package:ReminderApp/reminder_bloc.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:ReminderApp/cycle.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'action_buttons.dart';
import 'cycle_selector.dart';
import 'message_field.dart';
import 'time_selector.dart';

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
  String _message;
  DateTime time;
  Cycle _cycle;

  DateTime minimumTime;
  DateTime maximumTime;

  bool reminderExists;

  String dateMask = 'EEEE d MMM, yyyy';

  @override
  void initState() {
    super.initState();

    if (widget.reminder == null && widget.id == null) {
      throw new Exception("Either widget or id needs to be defined!");
    }

    _message = "";
    time = DateTime.now();
    minimumTime = time;
    maximumTime = DateTime(2100);
    _cycle = Cycle.daily;

    reminderExists = widget.reminder != null;

    if (reminderExists) {
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

  int getId() {
    if (widget.reminder != null) {
      return widget.reminder.id;
    } else {
      return widget.id;
    }
  }

  Future<void> deleteReminder() async {
    ReminderBloc _reminderBloc = BlocProvider.of<ReminderBloc>(context);

    ReminderAction rA = new ReminderAction(
      ReminderActionType.delete,
      reminder: widget.reminder,
    );
    _reminderBloc.add(rA);

    print("Reminder was deleted!");
  }

  Future<void> insertOrReplaceReminder() async {
    Reminder reminder = Reminder(
      getId(),
      _message,
      _cycle,
      getDate(),
      getTime(),
    );

    ReminderBloc _reminderBloc = BlocProvider.of<ReminderBloc>(context);

    ReminderAction rA = new ReminderAction(
      reminderExists ? ReminderActionType.replace : ReminderActionType.add,
      reminder: reminder,
    );
    _reminderBloc.add(rA);

    print("Reminder inserted or replaced!");
  }

  void setMessage(newMessage) {
    _message = newMessage;
  }

  void setTime(String val) {
    setState(() {
      time = DateTime.parse(val);
    });
  }

  void setCycle(newCycle) {
    setState(() {
      _cycle = newCycle;
    });
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
                MessageField(_message, setMessage),
                TimeSelector(
                  dateMask,
                  setTime,
                  time,
                  minimumTime,
                  maximumTime,
                ),
                CycleSelector(_cycle, setCycle)
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ActionButtons(
        reminderExists,
        insertOrReplaceReminder,
        deleteReminder,
      ),
    );
  }
}
