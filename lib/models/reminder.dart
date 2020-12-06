import 'package:ReminderApp/cycle.dart';
import 'package:intl/intl.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:ReminderApp/globals.dart';

class Reminder {
  int id;

  String message;
  Cycle cycle;
  String firstDate;
  String dayTime;

  Reminder(this.id, this.message, this.cycle, this.firstDate, this.dayTime);

  String calcNextDate() {
    return firstDate;
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
