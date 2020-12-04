import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_time_picker/date_time_picker.dart';

class TimeSelector extends StatelessWidget {
  String dateMask;

  String dayTime;
  String firstDate;

  Function setDayTime;
  Function setFirstDate;

  TimeSelector(
    this.dateMask,
    this.dayTime,
    this.firstDate,
    this.setDayTime,
    this.setFirstDate,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Start Time:"),
          DateTimePicker(
            type: DateTimePickerType.dateTimeSeparate,
            dateMask: dateMask,
            initialValue: firstDate + " " + dayTime,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            icon: Icon(Icons.event),
            dateLabelText: 'Date',
            timeLabelText: "Hour",
            onChanged: setDayTime,
          )
        ],
      ),
    );
  }
}
