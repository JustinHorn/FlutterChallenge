import 'package:ReminderApp/globals.dart';
import 'package:intl/intl.dart';
import 'package:timezone/standalone.dart';

extension MyDateTime on DateTime {
  bool isInTheFuture() {
    return this.isAfter(DateTime.now());
  }

  TZDateTime toTZ() {
    return TZDateTime.from(this, timeLocation);
  }
}

extension MyTZDateTime on TZDateTime {
  bool isInPast() {
    return this.microsecondsSinceEpoch -
            TZDateTime.from(DateTime.now(), timeLocation)
                .microsecondsSinceEpoch <
        0;
  }
}
