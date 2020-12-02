import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_time_picker/date_time_picker.dart';

class TimeSelector extends StatelessWidget {
  String dateMask;

  Function setTime;
  DateTime time;
  DateTime minimumTime;
  DateTime maximumTime;

  TimeSelector(
    this.dateMask,
    this.setTime,
    this.time,
    this.minimumTime,
    this.maximumTime,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Start Time:"),
          getDateTimePicker(),
        ],
      ),
    );
  }

  Widget getDateTimePicker() {
    return DateTimePicker(
      type: DateTimePickerType.dateTimeSeparate,
      dateMask: dateMask,
      initialValue: time.toString(),
      firstDate: minimumTime,
      lastDate: maximumTime,
      icon: Icon(Icons.event),
      dateLabelText: 'Date',
      timeLabelText: "Hour",
      onChanged: setTime,
    );
  }
}
