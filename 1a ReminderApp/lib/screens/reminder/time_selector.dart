import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TimeSelector extends StatelessWidget {
  Function setDayTime;
  Function setFirstDate;
  String dayTime;
  String firstDate;

  TimeSelector(
      this.dayTime, this.firstDate, this.setDayTime, this.setFirstDate);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Container(
          padding: EdgeInsets.only(top: 10),
          width: double.infinity,
          child: TextField(
            onTap: () {
              DatePicker.showTimePicker(
                context,
                showTitleActions: true,
                onChanged: setDayTime,
              );
            },
            readOnly: true,
            controller: TextEditingController(text: dayTime),
            decoration: InputDecoration(labelText: "Time"),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 20),
          width: double.infinity,
          child: TextField(
            onTap: () {
              DatePicker.showDatePicker(
                context,
                showTitleActions: true,
                minTime: DateTime(2000),
                maxTime: DateTime(2100),
                onChanged: setFirstDate,
              );
            },
            readOnly: true,
            controller: TextEditingController(text: firstDate),
            decoration: InputDecoration(labelText: "First Date"),
          ),
        ),
      ]),
    );
  }
}
