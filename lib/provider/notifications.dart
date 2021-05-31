import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_app_firestore_example/api/firebase_api.dart';
import 'package:todo_app_firestore_example/model/todo.dart';

class NotificationService extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  get flutterLocalNotificationsPlugin => _flutterLocalNotificationsPlugin;

  Future init() async {
    tz.initializeTimeZones();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/ic_launcher');
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        var todo = await FirebaseApi.readTodoById(payload);
        todo.isDone = !todo.isDone;
        FirebaseApi.updateTodo(todo);
      }
    });
  }

  //Sheduled Notification

  Future sheduledNotification(Todo deadlineTodo) async {
    var android = AndroidNotificationDetails("id", "channel", "description");

    var platform = new NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      "Todo : ${deadlineTodo.title} đã dí tới đít",
      "Bấm vào đây để đánh dấu là đã hoàn thành!",
      tz.TZDateTime.parse(tz.local, deadlineTodo.deadlineTime.toString()),
      platform,
      androidAllowWhileIdle: true,
      payload: deadlineTodo.id,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  //Cancel notification

  Future cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
