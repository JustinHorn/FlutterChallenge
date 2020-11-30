import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Reminder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Reminder'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum Cycle { once, daily, weekly, monthly }

extension CycleExtension on Cycle {
  String get name {
    switch (this) {
      case Cycle.once:
        return "once";
      case Cycle.daily:
        return "daily";
      case Cycle.weekly:
        return "weekly";
      case Cycle.monthly:
        return "monthly";
      default:
        return "";
    }
  }
}

class _MyHomePageState extends State<MyHomePage> {
  String _message;
  DateTime time;
  Cycle _cycle;

  @override
  void initState() {
    super.initState();

    _cycle = Cycle.once;
    _message = "";
    time = DateTime.now();
  }

  void logData() {
    print(_message);
    print(time);

    print(_cycle.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Create Reminder:',
                    style: TextStyle(
                        fontSize: 22.0, fontWeight: FontWeight.normal)),
                TextField(
                  decoration: InputDecoration(labelText: "Message"),
                  onChanged: (value) => _message = value,
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Start Time:"),
                      DateTimePicker(
                        type: DateTimePickerType.dateTimeSeparate,
                        dateMask: 'EEEE d MMM, yyyy',
                        initialValue: time.toString(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        icon: Icon(Icons.event),
                        dateLabelText: 'Date',
                        timeLabelText: "Hour",
                        //use24HourFormat: false,
                        //locale: Locale('pt', 'BR'),
                        selectableDayPredicate: (date) {
                          if (date.weekday == 6 || date.weekday == 7) {
                            return false;
                          }
                          return true;
                        },
                        onChanged: (val) => time = DateTime.parse(val),
                      ),
                      ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: Cycle.values
                              .map(
                                (cycle) => RaisedButton(
                                  padding: const EdgeInsets.all(0.0),
                                  onPressed: () {
                                    setState(() {
                                      _cycle = cycle;
                                    });
                                  },
                                  color: cycle == _cycle ? Colors.blue : null,
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    child: Text(cycle.name),
                                  ),
                                ),
                              )
                              .toList())
                    ],
                  ),
                ),
                FloatingActionButton(
                  onPressed: () => logData(),
                  tooltip: 'Create Reminder',
                  child: Icon(Icons.timer),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
