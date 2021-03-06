import 'package:ReminderApp/state/reminder_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state/database_helper.dart';
import 'models/reminder.dart';
import 'screens/reminder/reminder.dart';
import 'screens/home/home.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:timezone/data/latest.dart' as tz;
import 'Notificaitions/NotificationPlugin.dart';

void main() {
  Bloc.observer = BlocObserver();
  tz.initializeTimeZones();

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
          primarySwatch: Colors.green,
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
