import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'models/reminder.dart';
import 'screens/reminder/reminder.dart';
import 'screens/home/home.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_file.dart';

void main() {
  Bloc.observer = BlocObserver();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReminderBloc(),
      child: MaterialApp(
        navigatorKey: navigatorkey,
        title: 'Remindely',
        theme: ThemeData(
          primaryColor: Colors.blue,
          primarySwatch: Colors.amber,
          primaryTextTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.white),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(title: 'Remindely'),
      ),
    );
  }
}

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
  ReminderBloc() : super([]);

  @override
  Stream<List<Reminder>> mapEventToState(ReminderAction event) async* {
    List<Reminder> newList = List.from(state);
    switch (event.type) {
      case ReminderActionType.addAll:
        newList.addAll(event.reminders);
        yield newList;
        break;
      case ReminderActionType.add:
        newList.add(event.reminder);
        yield newList;
        break;
      case ReminderActionType.replace:
        int index =
            newList.indexWhere((element) => element.id == event.reminder.id);
        newList[index] = event.reminder;
        yield newList;
        break;
      case ReminderActionType.delete:
        int index =
            newList.indexWhere((element) => element.id == event.reminder.id);
        newList.remove(index);
        yield newList;
        break;
      default:
        addError(Exception('unsupported event'));
    }
  }
}
