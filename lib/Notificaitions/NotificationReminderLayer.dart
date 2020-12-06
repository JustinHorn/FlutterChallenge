import 'package:ReminderApp/models/reminder.dart';
import 'package:ReminderApp/models/reminder_notification.dart';
import 'package:ReminderApp/state/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:timezone/standalone.dart';

import 'package:ReminderApp/globals.dart';

import '../cycle.dart';
import 'NotificationPlugin.dart';

DatabaseHelper dbHelper = DatabaseHelper();

int uniqueID = 1;

extension on DateTime {
  bool isInTheFuture() {
    return this.isAfter(DateTime.now());
  }

  TZDateTime toTZ() {
    return TZDateTime.from(this, timeLocation);
  }
}

extension on TZDateTime {
  bool isInPast() {
    return this.microsecondsSinceEpoch -
            TZDateTime.from(DateTime.now(), timeLocation)
                .microsecondsSinceEpoch <
        0;
  }
}

DateTime getDayFloorDayTime() {
  return DateFormat("dd.MM.yyyy")
      .parse(DateFormat("dd.MM.yyyy").format(DateTime.now()));
}

Future<void> scheduleReminderNotification(Reminder reminder) async {
  TZDateTime firstDateTime = reminder.getFirstDateTime().toTZ();
  TZDateTime nextTime = firstDateTime;

  switch (reminder.cycle) {
    case Cycle.once:
      schedule(ReminderNotification(uniqueID++, reminder, nextTime));
      break;
    case Cycle.daily:
      if (!firstDateTime.isInTheFuture()) {
        nextTime = getDayFloorDayTime().add(reminder.getDayTimeDuration());
      }

      List<ReminderNotification> newNotificationList =
          List<ReminderNotification>();

      for (int i = 0; i < NSiA; i++) {
        ReminderNotification rN =
            ReminderNotification(uniqueID++, reminder, nextTime);
        newNotificationList.add(rN);
        nextTime = nextTime.add(Duration(days: 1));
        dbHelper.insertNotification(rN);
        schedule(rN);
      }

      break;
    default:
  }
}

Future<void> schedule(ReminderNotification rN) async {
  Reminder reminder = rN.reminder;
  TZDateTime scheduleTime = reminder.getTZFirstDateTime();

  if (scheduleTime.isInPast()) {
    print("Notification was not schedulded do to Time being in the past!");
  } else {
    await notificationPluginLOL.scheduleNotification(
      rN.id,
      reminder.message,
      null,
      scheduleTime,
    );
  }
}

Future<void> cancelReminderNotification(Reminder reminder) async {
  switch (reminder.cycle) {
    case Cycle.once:

    case Cycle.daily:
      reminder.notifications.forEach((ReminderNotification element) {
        notificationPluginLOL.cancelNotification(element.id);
        dbHelper.deleteNotification(element.id);
      });
      reminder.resetList();

      break;
    default:
  }
}

Future<void> replaceReminderNotification(Reminder reminder) async {
  await cancelReminderNotification(reminder);
  await scheduleReminderNotification(reminder);
}
