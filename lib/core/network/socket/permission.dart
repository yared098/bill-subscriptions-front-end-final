
import 'package:permission_handler/permission_handler.dart';

Future<void> requestNotificationPermission() async {
  await Permission.notification.request();
}