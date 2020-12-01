import 'package:ReminderApp/cycle.dart';
import 'package:intl/intl.dart';

class Reminder {
  int id;

  String message;
  Cycle cycle;
  String firstDate;
  String time;

  Reminder(this.id, this.message, this.cycle, this.firstDate, this.time);

  String calcNextDate() {
    return firstDate;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "message": message,
      "cycle": cycle.id,
      "firstDate": firstDate,
      "time": time,
    };
  }

  DateTime getFirstDateTime() {
    String whole = firstDate + " " + time;
    DateTime dt =
        DateFormat("EEEE dd.MM.yyyy HH:mm").parse("Monday 01.12.2019 17:00");

    return dt;
  }
}
