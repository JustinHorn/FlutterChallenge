import 'dart:async';

import 'package:ReminderApp/globals.dart';
import 'package:ReminderApp/models/reminder_notification.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../cycle.dart';
import '../models/reminder.dart';
import 'package:intl/intl.dart';

import 'package:ReminderApp/date_extensions.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), "reminder.db"),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE reminder(id INTEGER PRIMARY KEY, message TEXT, cycle INTEGER, firstDate VARCHAR(25), dayTime VARCHAR(10),active INTEGER)",
        );
        db.execute(
          "CREATE TABLE notification(id INTEGER PRIMARY KEY, reminderID INTEGER, time VARCHAR(50))",
        );

        return db;
      },
      version: 1,
    );
  }

  Future<void> insertReminder(Reminder reminder) async {
    Database _db = await database();
    await _db.insert('reminder', reminder.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertNotification(ReminderNotification rN) async {
    Database _db = await database();
    await _db.insert('notification', rN.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  Future<void> deleteNotification(int notificatioID) async {
    Database _db = await database();
    await _db.delete("notification", where: "id = ${notificatioID}");
  }

  Future<void> deleteReminder(int reminderId) async {
    Database _db = await database();
    await _db.delete("reminder", where: "id = ${reminderId}");
  }

  Future<List<Reminder>> getReminders() async {
    Database _db = await database();
    List<Map<String, dynamic>> reminderMap = await _db.query("reminder");
    List<Map<String, dynamic>> notificationMap =
        await _db.query("notification");

    if (notificationMap.length > 0 &&
        notificationMap.last["id"] > uniqueNotificationID) {
      uniqueNotificationID = notificationMap.last["id"] + 1;
    }

    return List.generate(
      reminderMap.length,
      (index) {
        Reminder reminder = Reminder(
          reminderMap[index]["id"],
          reminderMap[index]["message"],
          CycleExtension.getById(reminderMap[index]["cycle"]),
          reminderMap[index]["firstDate"],
          reminderMap[index]["dayTime"],
          active: reminderMap[index]["active"] == 1,
        );

        List<ReminderNotification> nR = notificationMap
            .where((nR) => nR["reminderID"] == reminder.id)
            .map((nR) => ReminderNotification(nR["id"], reminder,
                DateFormat(notificationTimeMask).parse(nR["time"]).toTZ()))
            .toList();
        return reminder;
      },
    );
  }
}
