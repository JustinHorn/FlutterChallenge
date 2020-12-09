import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Feedback'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  String feedback = "";

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: c_width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Result Message:\n"),
                        Text(
                          "${feedback}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: RaisedButton(
                onPressed: () {
                  showAlertDialog(context);
                },
                child: Text("Give feedback!"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> sendFeedback(double feedbackRating) async {
    Response result = await post(
      'https://europe-west1-epap-fg44.cloudfunctions.net/request_verifyCodingChallenge',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + DotEnv().env['BEARER_TOKEN']
      },
      body: jsonEncode(<String, dynamic>{
        'feedback': feedbackRating,
      }),
    );
    setState(() {
      feedback = jsonDecode(result.body)["displayText"];
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons

    double rating = 0.5;

    Widget submitButton = FlatButton(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor,
        ),
        child: Text(
          "Submit",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
        sendFeedback(rating);
      },
    );

    List<String> strings = [
      "very unsatisfied",
      "unsatisfied",
      "satisfied",
      "very satisfied",
      "very satisfied"
    ];

    List<IconData> iconList = [
      Icons.sentiment_very_dissatisfied,
      Icons.sentiment_dissatisfied,
      Icons.sentiment_satisfied,
      Icons.sentiment_very_satisfied,
      Icons.sentiment_very_satisfied
    ];
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("How satisfied are you with the scan?"),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(strings[(rating * 4).floor()]),
              Icon(
                iconList[(rating * 4).floor()],
                size: 100.0,
              ),
              Slider(
                value: rating,
                onChanged: (x) {
                  setState(() {
                    rating = x;
                  });
                },
              )
            ],
          );
        },
      ),
      actions: [
        submitButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
