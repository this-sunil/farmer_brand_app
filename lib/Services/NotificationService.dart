import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  NotificationService._();
  static NotificationService get instance => NotificationService._();
  init() async {
    List<NotificationChannel> channels = [
      NotificationChannel(
        channelKey: 'Basic-Channel',
        channelName: 'Basic Channel',
        channelDescription: 'Basic Channel Notification',
      ),
    ];
    await AwesomeNotifications().initialize(null, channels, debug: true).whenComplete((){
      log("Notification Initialize=>");
    });
  }

  createNotification(String title, String description) async {
    int id = DateTime.now().millisecondsSinceEpoch;
    NotificationContent content = NotificationContent(
      id: id,
      channelKey: 'Basic-Channel',
      title: title,
      body: description,
      wakeUpScreen: true,
      notificationLayout: NotificationLayout.Default,
      category: NotificationCategory.Message
    );
    await AwesomeNotifications().createNotification(content: content,schedule: NotificationCalendar(second: 5));
    await AwesomeNotifications().showNotificationConfigPage();
  }
}
