import 'package:ReminderApp/cycle.dart';
import 'package:intl/intl.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:ReminderApp/globals.dart';

import 'reminder_notification.dart';

class Reminder {
  int id;

  String message;
  Cycle cycle;
  String firstDate;
  String dayTime;

  List<ReminderNotification> notifications = List<ReminderNotification>();

  Reminder(this.id, this.message, this.cycle, this.firstDate, this.dayTime) {
    print(firstDate);
  }

  void resetList() {
    notifications = List<ReminderNotification>();
  }

  Duration getDayTimeDuration() {
    String hours = dayTime.split(":")[0];
    String minutes = dayTime.split(":")[1];
    return Duration(
      hours: int.parse(hours),
      minutes: int.parse(minutes),
    );
  }

  String calcNextDate() {
    if (notifications.length == 0) {
      return "";
    }
    return DateFormat("EEEE dd.MM.yyyy").format(notifications.first.time);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "message": message,
      "cycle": cycle.id,
      "firstDate": firstDate,
      "dayTime": dayTime,
    };
  }

  DateTime getFirstDateTime() {
    String whole = firstDate + " " + dayTime;

    DateTime dt = DateFormat("EEEE dd.MM.yyyy HH:mm").parse(whole);

    return dt;
  }

  tz.TZDateTime getTZFirstDateTime() {
    return tz.TZDateTime.from(getFirstDateTime(), timeLocation);
  }
}
