import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/standalone.dart' as tz;

class NotificationPlugin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final BehaviorSubject<ReceivedNotification>
      didReceivedLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();

  InitializationSettings initializationSettings;

  NotificationPlugin() {
    init();
  }

  init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    initializePlatformSpecifics();
  }

  initializePlatformSpecifics() {
    var android = AndroidInitializationSettings("app_notf_icon");
    var iOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        ReceivedNotification receivedNotification = ReceivedNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
        );

        didReceivedLocalNotificationSubject.add(receivedNotification);
      },
    );
    initializationSettings = InitializationSettings(
      android: android,
      iOS: iOS,
    );
    print("init platform");
    setListenerForLowerVersions((a) {});
    setOnNotificationClick((a) {});
  }

  _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: false,
          badge: true,
          sound: true,
        );
  }

  setListenerForLowerVersions(Function onNotificationInLowerVersions) {
    didReceivedLocalNotificationSubject.listen((receivedNotification) {
      onNotificationInLowerVersions(receivedNotification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      onNotificationClick(payload);
    });
  }

  Future<void> showNotification(
    id,
    title,
    body, {
    payload = "Test Payload",
  }) async {
    var platformChannelSpecifics = getNotificaitonDetails();
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> scheduleNotification(
    id,
    title,
    body,
    tz.TZDateTime dateTime, {
    payload = "Test Payload",
    androidAllowWhileIdle = false,
  }) async {
    var platformChannelSpecifics = getNotificaitonDetails();

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      dateTime,
      platformChannelSpecifics,
      payload: payload,
      androidAllowWhileIdle: androidAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(id) async {
    flutterLocalNotificationsPlugin.cancel(id);
  }

  NotificationDetails getNotificaitonDetails() {
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID REMINDER',
      'CHANNEL_NAME REMINDER',
      'CHANNEL_DESCRIPTION REMINDER',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      styleInformation: DefaultStyleInformation(true, true),
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidChannelSpecifics,
      iOS: iosChannelSpecifics,
    );
    return platformChannelSpecifics;
  }

  Future<int> getPendingNotificationCount() async {
    List<PendingNotificationRequest> p =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print(p.first);
    return p.length;
  }
}

NotificationPlugin notificationPluginLOL = NotificationPlugin();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}
