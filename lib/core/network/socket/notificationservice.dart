import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:permission_handler/permission_handler.dart';

Future<void> requestNotificationPermission() async {
  await Permission.notification.request();
}
class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // =========================
  // INIT
  // =========================
  static Future<void> init() async {
    // const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const android = AndroidInitializationSettings('ic_notification');

    const settings = InitializationSettings(
      android: android,
    );

    await _plugin.initialize(
      settings: settings,
    );
  }

  // =========================
  // SHOW NOTIFICATION
  // =========================
  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'bill_channel',
      'Bills Notifications',
      channelDescription: 'Notifications for bills and subscriptions',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
    );

     await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }
}