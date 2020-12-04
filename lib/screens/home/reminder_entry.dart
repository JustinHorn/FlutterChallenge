import 'package:ReminderApp/models/reminder.dart';
import 'package:flutter/material.dart';
import 'package:ReminderApp/cycle.dart';

class ReminderHomeEntry extends StatelessWidget {
  Reminder reminder;
  Function onTap;

  ReminderHomeEntry(this.reminder, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(reminder),
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
                .toList(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'First: ${reminder.firstDate}',
                    style: Theme.of(context).primaryTextTheme.bodyText1,
                  ),
                ),
                Text(
                  reminder.id.toString(),
                  style: Theme.of(context).primaryTextTheme.bodyText1,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  List<String> getReminderDataAsList() {
    return [
      "Cycle: " + reminder.cycle.name,
      "Time: " + reminder.dayTime,
      "Next: " + reminder.calcNextDate(),
    ];
  }
}
