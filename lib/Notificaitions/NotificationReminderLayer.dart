import 'package:ReminderApp/models/reminder.dart';
import 'package:timezone/standalone.dart' as tz;

import 'package:ReminderApp/globals.dart';

import 'NotificationPlugin.dart';

Future<void> scheduleReminderNotification(Reminder reminder) async {
  tz.TZDateTime scheduleTime = reminder.getTZFirstDateTime();

  if (isTZInPast(scheduleTime)) {
    print("Notification was not schedulded do to Time being in the past!");
  } else {
    await notificationPluginLOL.scheduleNotification(
        reminder.id, reminder.message, null, scheduleTime);
  }
}

bool isTZInPast(tz.TZDateTime tzDateTime) {
  return tzDateTime.microsecondsSinceEpoch -
          tz.TZDateTime.from(DateTime.now(), timeLocation)
              .microsecondsSinceEpoch <
      0;
}

Future<void> cancelReminderNotification(Reminder reminder) async {
  await notificationPluginLOL.cancelNotification(reminder.id);
}

Future<void> replaceReminderNotification(Reminder reminder) async {
  await cancelReminderNotification(reminder);
  await scheduleReminderNotification(reminder);
}
