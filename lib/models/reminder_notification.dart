import 'package:ReminderApp/globals.dart';
import 'package:intl/intl.dart';
import 'package:timezone/standalone.dart' as tz;

import 'reminder.dart';

class ReminderNotification {
  int id;
  Reminder reminder;
  tz.TZDateTime time;

  ReminderNotification(this.id, this.reminder, this.time) {
    reminder.notifications.add(this);
  }

  DateTime getDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "reminderId": reminder.id,
      "time": DateFormat(notificationTimeMask).format(getDateTime()),
    };
  }
}
