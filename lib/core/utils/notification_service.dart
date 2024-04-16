import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:flutter/material.dart' show Colors;

class NotificationService {
  final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
  // final AwesomeNotificationsFcm _awesomeNotificationsFcm = AwesomeNotificationsFcm();

  Future<void> initializeLocalNotifications({
    required String channelKey,
    required String channelName,
    required String channelDescription,
  }) async {
    await awesomeNotifications.initialize(
      // set the icon to null if you want to use the default app icon
      // otherwise, you can set a custom icon'
      // 'resource://drawable/res_notification_icon',
      null,
      [
        NotificationChannel(
          channelKey: channelKey,
          channelName: channelName,
          channelDescription: channelDescription,
          playSound: true,
          // For android, set the importance to show up notifications on screen
          importance: NotificationImportance.High,
          // Private notifications will not be shown on the lock screen
          defaultPrivacy: NotificationPrivacy.Private,
          // Show the badge on the app icon
          channelShowBadge: true,
          defaultColor: Colors.deepPurple,
          ledColor: Colors.deepPurple,
        )
      ],
      debug: true,
      languageCode: 'ko',
    );
  }

  static Future<void> initializeRemoteNotification() async {}
}
