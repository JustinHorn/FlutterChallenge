import 'package:flutter_bloc/flutter_bloc.dart';

import 'database_helper.dart';
import 'models/reminder.dart';

enum ReminderActionType { add, replace, delete, addAll }

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
      case ReminderActionType.addAll:
        newList.addAll(event.reminders);
        event.reminders.forEach((element) async {
          await databaseHelper.insertReminder(element);
        });
        yield newList;
        break;
      case ReminderActionType.add:
        newList.add(event.reminder);
        await databaseHelper.insertReminder(event.reminder);

        yield newList;
        break;
      case ReminderActionType.replace:
        int index =
            newList.indexWhere((element) => element.id == event.reminder.id);
        newList[index] = event.reminder;
        await databaseHelper.insertReminder(event.reminder);

        yield newList;
        break;
      case ReminderActionType.delete:
        int index =
            newList.indexWhere((element) => element.id == event.reminder.id);
        newList.removeAt(index);
        await databaseHelper.deleteReminder(event.reminder.id);

        yield newList;
        break;
      default:
        addError(Exception('unsupported event'));
    }
  }
}
