import 'package:ReminderApp/Notificaitions/NotificationReminderLayer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'database_helper.dart';
import '../models/reminder.dart';
import 'package:timezone/standalone.dart' as tz;

enum ReminderActionType { init, add, replace, delete }

class ReminderAction {
  ReminderActionType _type;

  ReminderActionType get type => _type;

  set type(ReminderActionType type) {
    _type = type;
  }

  Reminder reminder;

  List<Reminder> reminders;

  ReminderAction(this._type, {this.reminder, this.reminders});
}

class ReminderBloc extends Bloc<ReminderAction, List<Reminder>> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  ReminderBloc() : super([]);

  @override
  Stream<List<Reminder>> mapEventToState(ReminderAction event) async* {
    List<Reminder> newList = List.from(state);

    switch (event.type) {
      case ReminderActionType.init:
        List<Reminder> r = await databaseHelper.getReminders();

        r.forEach((element) {
          replaceReminderNotification(element);
        });
        yield r;
        break;

      case ReminderActionType.add:
        newList.add(event.reminder);
        await databaseHelper.insertReminder(event.reminder);
        scheduleReminderNotification(event.reminder);
        yield newList;
        break;
      case ReminderActionType.replace:
        replaceReminderInList(newList, event.reminder);
        await databaseHelper.insertReminder(event.reminder);
        replaceReminderNotification(event.reminder);
        yield newList;
        break;
      case ReminderActionType.delete:
        removeReminderFromList(newList, event.reminder);
        await databaseHelper.deleteReminder(event.reminder.id);
        cancelReminderNotification(event.reminder);
        yield newList;
        break;
      default:
        addError(Exception('unsupported event'));
    }
  }

  void replaceReminderInList(List<Reminder> list, Reminder reminder) {
    int index = getReminderIndexInList(list, reminder);
    list[index] = reminder;
  }

  void removeReminderFromList(List<Reminder> list, Reminder reminder) {
    int index = getReminderIndexInList(list, reminder);
    list.removeAt(index);
  }

  int getReminderIndexInList(List<Reminder> list, Reminder reminder) {
    return list.indexWhere((element) => element.id == reminder.id);
  }
}
