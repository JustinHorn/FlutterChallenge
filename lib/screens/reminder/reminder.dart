import 'package:ReminderApp/models/reminder.dart';
import 'package:ReminderApp/state/reminder_bloc.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:ReminderApp/cycle.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'action_buttons.dart';
import 'cycle_selector.dart';
import 'title_field.dart';
import 'time_selector.dart';

import 'package:ReminderApp/Notificaitions/NotificationPlugin.dart';

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

  String dayTime = "05:30";
  String firstDate = " 2020-12-04 11:48:11.814341";

  bool reminderExists;

  String dateMask = 'EEEE dd.MM.yyyy';

  ReminderBloc _reminderBloc;

  @override
  void initState() {
    super.initState();

    notificationPluginLOL.setListenerForLowerVersions((a) {});
    notificationPluginLOL.setOnNotificationClick((a) {});
    _reminderBloc = BlocProvider.of<ReminderBloc>(context);
    if (widget.reminder == null && widget.id == null) {
      throw new Exception("Either widget or id needs to be defined!");
    }

    _message = "";
    time = DateTime.now();

    _cycle = Cycle.daily;

    reminderExists = widget.reminder != null;

    if (reminderExists) {
      _message = widget.reminder.message;
      time = widget.reminder.getFirstDateTime();

      _cycle = widget.reminder.cycle;
    }

    dayTime = DateFormat("HH:mm").format(time);
    firstDate = DateFormat(dateMask).format(time);
  }

  void setDayTime(value) {
    dayTime = value;
  }

  void setFirstDate(value) {
    firstDate = value;
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
                TitleField(_message, setMessage),
                DateTimePicker(
                  type: DateTimePickerType.date,
                  dateMask: dateMask,
                  initialValue: DateFormat("EEEE dd.MM.yyyy").format(time),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  icon: Icon(Icons.event),
                  dateLabelText: 'First Day',
                  timeLabelText: "Hour",
                  onChanged: setFirstDate,
                ),
                DateTimePicker(
                  type: DateTimePickerType.time,
                  dateMask: dateMask,
                  initialValue: dayTime,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  icon: Icon(Icons.access_alarm),
                  dateLabelText: 'Date',
                  timeLabelText: "Time of Day",
                  onChanged: setDayTime,
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

  int getId() {
    if (widget.reminder != null) {
      return widget.reminder.id;
    } else {
      return widget.id;
    }
  }

  Future<void> deleteReminder() async {
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
      firstDate,
      dayTime,
    );

    ReminderAction rA = new ReminderAction(
      reminderExists ? ReminderActionType.replace : ReminderActionType.add,
      reminder: reminder,
    );
    _reminderBloc.add(rA);

    print("Reminder ${(reminderExists ? 'inserted' : 'replaced')}!");
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
}
