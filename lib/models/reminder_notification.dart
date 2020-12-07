import 'package:ReminderApp/Notificaitions/NotificationPlugin.dart';
import 'package:ReminderApp/globals.dart';
import 'package:intl/intl.dart';
import 'package:timezone/standalone.dart';

import 'reminder.dart';

import 'package:ReminderApp/date_extensions.dart';

class ReminderNotification {
  int id;
  Reminder reminder;
  TZDateTime time;

  ReminderNotification(this.id, this.reminder, this.time) {
    reminder.notifications.add(this);
    schedule();
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

  Future<void> schedule() async {
    if (time.isInPast()) {
      print("Notification was not schedulded do to Time being in the past!");
    } else {
      await notificationPluginLOL.scheduleNotification(
        id,
        reminder.message,
        null,
        time,
      );
    }
  }
}
