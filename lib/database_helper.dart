import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'cycle.dart';
import 'models/reminder.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), "reminders.db"),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE reminders(id INTEGER PRIMARY KEY, message TEXT, cycle INTEGER, firstDate VARCHAR(20), time VARCHAR(10))",
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

  Future<void> deleteReminder(int reminderId) async {
    Database _db = await database();
    await _db.delete("reminder", where: "id = ${reminderId}");
  }

  Future<List<Reminder>> getReminders() async {
    Database _db = await database();
    List<Map<String, dynamic>> reminderMap = await _db.query("tasks");
    return List.generate(
      reminderMap.length,
      (index) {
        return Reminder(
          reminderMap[index]["id"],
          reminderMap[index]["message"],
          Cycle.getById(reminderMap[index]["cycle"]),
          reminderMap[index]["firstDate"],
          reminderMap[index]["time"],
        );
      },
    );
  }
}
