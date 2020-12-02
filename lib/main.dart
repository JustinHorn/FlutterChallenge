import 'package:flutter/material.dart';
import 'screens/reminder/reminder.dart';
import 'screens/home.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_file.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
