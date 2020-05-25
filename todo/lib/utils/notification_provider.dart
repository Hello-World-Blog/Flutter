import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationProvider {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  static final initializationSettingsIOS = IOSInitializationSettings();
  static final initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);

  final MethodChannel platform =
      MethodChannel('crossingthestreams.io/resourceResolver');

  static final NotificationProvider instance = NotificationProvider._();

  NotificationProvider._() {
    init();
  }

  Future<void> init() async {
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification(
      String title, DateTime date, int priority,int id) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Todo Channel',
      'Tasks Channel',
      'Channel for TODO App,',
      enableVibration: true,
      importance: Importance.High,
      category: 'reminder',
      visibility: NotificationVisibility.Public,
      styleInformation: DefaultStyleInformation(true, true),
    );
    String body = "Task Reminder.";
    body+=" Priority: ";
    body +=
        priority == 1 ? "Low" : priority == 2 ? "Medium" : "High";
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        id, '$title', body, date, platformChannelSpecifics,androidAllowWhileIdle: true);
  }
  Future<void> cancelNotification(int id)async{
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
