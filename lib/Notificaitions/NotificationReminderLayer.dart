import 'package:ReminderApp/models/reminder.dart';
import 'package:ReminderApp/models/reminder_notification.dart';
import 'package:ReminderApp/state/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:timezone/standalone.dart';

import 'package:ReminderApp/globals.dart';

import 'package:ReminderApp/cycle.dart';
import 'NotificationPlugin.dart';

import 'package:ReminderApp/date_extensions.dart';

DatabaseHelper dbHelper = DatabaseHelper();

DateTime getDayFloorDayTime() {
  return DateFormat("dd.MM.yyyy")
      .parse(DateFormat("dd.MM.yyyy").format(DateTime.now()));
}

Future<void> scheduleReminderNotification(Reminder reminder) async {
  if (reminder.active) {
    TZDateTime firstDateTime = reminder.getFirstDateTime().toTZ();

    if (reminder.cycle == Cycle.once) {
      addNotifications(reminder, firstDateTime, 1);
    } else {
      TZDateTime nextTime = getNextFutureScheduledTime(reminder);

      addNotifications(reminder, nextTime, NSiA);
    }
  }
}

void addNotifications(Reminder reminder, TZDateTime nextTime, int iterations) {
  if (nextTime == null) {
    throw new Exception("nextTime is not allowed to be null");
  }

  for (int i = 0; i < iterations; i++) {
    ReminderNotification rN = ReminderNotification(uniqueNotificationID++,
        reminder, nextTime.add(reminder.cycle.getTimeDistance(i)));
    dbHelper.insertNotification(rN);
  }
}

/// could get perfomance issues if the interval is small and the start day a long time away
/// but it would take some years for that to take affect - if it even ever does.
TZDateTime getNextFutureScheduledTime(Reminder reminder) {
  TZDateTime nextTime = reminder.getFirstDateTime().toTZ();
  while (!nextTime.isInTheFuture()) {
    nextTime = nextTime.add(reminder.cycle.getTimeDistance(1));
  }
  return nextTime;
}

Future<void> cancelReminderNotification(Reminder reminder) async {
  if (reminder == null) {
    throw new Exception("reminder is not allowed to be null!");
  }
  reminder.notifications.forEach((ReminderNotification element) {
    print("cancled notification: " + element.id.toString());
    notificationPluginLOL.cancelNotification(element.id);
    dbHelper.deleteNotification(element.id);
  });
  reminder.resetList();
}

Future<void> replaceReminderNotification(Reminder reminder) async {
  await cancelReminderNotification(reminder);
  await scheduleReminderNotification(reminder);
}
