import 'package:accident_detector/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
class NotificationService {
  //Singleton pattern
  static final NotificationService _notificationService =
  NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();

  //instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();


  final AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('app_icon');

  Future<void> init() async {

    //Initialization Settings for Android
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    //Initialization Settings for iOS
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    //InitializationSettings for initializing settings for both platforms (Android & iOS)
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

  }


  final AndroidNotificationDetails _androidNotificationDetails =
  const AndroidNotificationDetails(
    'channel ID',
    'channel name',
    channelDescription: "",
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );


  final IOSNotificationDetails _iosNotificationDetails = const IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      badgeNumber: 20,
      attachments: <IOSNotificationAttachment>[],
      subtitle: "String",
      threadIdentifier: "String?"
  );
  Future selectNotification(String payload,context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => MyHomePage(payload:payload)),
    );
  }

  Future<void> showNotifications() async {
    NotificationDetails platformChannelSpecifics =
    NotificationDetails(
        android: _androidNotificationDetails,
        iOS: _iosNotificationDetails);
   var de = await flutterLocalNotificationsPlugin.show(
      0,
      'Notification Title',
      'This is the Notification Body',
      platformChannelSpecifics,
      payload: 'Notification Payload',
    );
  // debugPrint(de);
}}