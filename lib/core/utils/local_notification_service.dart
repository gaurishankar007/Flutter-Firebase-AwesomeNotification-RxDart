import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart' show Colors, MaterialPageRoute;

import '../../features/notification/views/test_notification.dart';
import '../../main.dart';
import 'notification_time_picker.dart';
import 'unique_id.dart';

class LocalNotificationService {
  ///  **************************
  /// INITIALIZE NOTIFICATIONS
  /// **************************

  static Future<void> initializeLocalNotifications({
    required String channelKey,
    required String channelName,
    required String channelDescription,
    bool showBadge = false,
    bool locked = false,
    String? soundSource,
  }) async {
    await AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      // otherwise, you can set a custom icon
      // 'resource://drawable/res_notification_icon',
      null,
      [
        NotificationChannel(
          channelKey: channelKey,
          channelName: channelName,
          channelDescription: channelDescription,
          playSound: true,
          defaultColor: Colors.deepPurple,
          ledColor: Colors.deepPurple,
          // For android, set the importance to show up notifications on screen
          importance: NotificationImportance.High,
          // Private notifications will not be shown on the lock screen
          defaultPrivacy: NotificationPrivacy.Private,
          // Show the badge on the app icon
          channelShowBadge: showBadge,
          // Lock the notification to prevent it from being dismissed after swapping
          locked: locked,
          // Set a custom sound for the notification
          soundSource: soundSource,
        )
      ],
      debug: true,
    );
  }

  // Get the initial notification action when the app is launched by a notification
  // This method will be called whenever the app is opened
  static Future<void> getInitialNotificationAction() async {
    ReceivedAction? receivedAction = await AwesomeNotifications().getInitialNotificationAction(
      removeFromActionEvents: true,
    );

    // As this method is called when the app is opened,
    // The notification action will be null if the app is not launched by a notification
    // Therefore, we need to check if the notification action is not null
    if (receivedAction != null) {
      log('App launched by a notification action: $receivedAction');

      // Data send from firebase message
      final extraDataReceived = receivedAction.payload;
      log(extraDataReceived.toString());

      // Adding a delay to navigate to the test notification screen
      // Because this method is called in the main method
      // And the navigator is not ready (navigatorKey.currentState is null)
      // That means the material app is not initialized yet
      Future.delayed(const Duration(milliseconds: 500)).then((_) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => TestNotification(
              goBack: () {},
            ),
          ),
        );
      });
    }
  }

  static Future<void> initializeIsolateReceivePort() async {
    final receivePort = ReceivePort('Notification action port in main isolate')
      ..listen((silentData) => onActionReceivedImplementationMethod(silentData));

    IsolateNameServer.registerPortWithName(receivePort.sendPort, 'notification_action_port');
  }

  static Future<void> onActionReceivedImplementationMethod(ReceivedAction receivedAction) async {
    // Navigate to the test notification screen
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => TestNotification(
          goBack: () {},
        ),
      ),
    );
  }

  static Future<bool> isNotificationAllowed() => AwesomeNotifications().isNotificationAllowed();

  static Future<bool> requestNotification() =>
      AwesomeNotifications().requestPermissionToSendNotifications();

  ///  *********************
  ///  CREATE NOTIFICATIONS
  ///  *********************

  static Future<void> showBasicNotification({
    required String channelKey,
    required String title,
    required String body,
    required String imageAssetPath,
  }) async {
    final notificationContent = NotificationContent(
      // Not specifying id or channelKey, notification will not be created
      id: uniqueId(),
      channelKey: channelKey,
      // Not specifying title or body, notification will be created but not be displayed
      title: title,
      body: body,
      bigPicture: "asset://$imageAssetPath",
      notificationLayout: NotificationLayout.BigPicture,
    );

    await AwesomeNotifications().createNotification(content: notificationContent);
  }

  static Future<void> showReminderNotification({
    required String channelKey,
    required String title,
    required String body,
    required NotificationWeekAndTime notificationWeekAndTime,
  }) async {
    final notificationContent = NotificationContent(
      id: uniqueId(),
      channelKey: channelKey,
      title: title,
      body: body,
      notificationLayout: NotificationLayout.Default,
      category: NotificationCategory.Reminder,
      wakeUpScreen: true,
    );

    final actionButtons = [
      NotificationActionButton(
        key: 'mark_done',
        label: 'Mark Done',
      ),
    ];

    final schedule = NotificationCalendar(
      weekday: notificationWeekAndTime.dayOfTheWeek,
      hour: notificationWeekAndTime.timeOfDay.hour,
      minute: notificationWeekAndTime.timeOfDay.minute,
      second: 1,
      millisecond: 1,
      repeats: true,
      preciseAlarm: true,
      allowWhileIdle: true,
    );

    await AwesomeNotifications().createNotification(
      content: notificationContent,
      actionButtons: actionButtons,
      schedule: schedule,
    );
  }

  static Future<void> cancelReminderNotifications() async {
    await AwesomeNotifications().cancelAllSchedules();
  }

  static Future<List<NotificationModel>> getScheduledNotifications() async {
    return await AwesomeNotifications().listScheduledNotifications();
  }

  ///  **********************************************************
  ///  LISTEN NOTIFICATION ACTIONS (WHEN NOTIFICATION IS TAPPED)
  ///  **********************************************************
  static setListener() async {
    await AwesomeNotifications().setListeners(
      onNotificationCreatedMethod: LocalNotificationService.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: LocalNotificationService.onNotificationDisplayedMethod,
      onActionReceivedMethod: LocalNotificationService.onActionReceivedMethod,
      onDismissActionReceivedMethod: LocalNotificationService.onDismissActionReceivedMethod,
    );
  }

  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    int? id = receivedNotification.id;
    String? channelKey = receivedNotification.channelKey;
    log('Notification created: $id, channelKey: $channelKey');
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    int? id = receivedNotification.id;
    String? channelKey = receivedNotification.channelKey;
    log('Notification displayed: $id, channelKey: $channelKey');
  }

  // Handles the notification action when the app is in the foreground or background or closed
  // This function will be called when the app is launched by a notification
  // if the initial page is listening to the notification actions
  // Works for both local and remote notifications
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    int? id = receivedAction.id;
    String? channelKey = receivedAction.channelKey;
    // Data send from firebase message
    final extraDataReceived = receivedAction.payload;

    log(extraDataReceived.toString());
    log('Action received: $id, channelKey: $channelKey');

    // Removing the badge count on iOS app icon
    if (Platform.isIOS) {
      final badgeCount = await AwesomeNotifications().getGlobalBadgeCounter();
      if (badgeCount > 0) {
        await AwesomeNotifications().setGlobalBadgeCounter(badgeCount - 1);
      }
    }
  }

  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    int? id = receivedAction.id;
    String? channelKey = receivedAction.channelKey;
    log('Dismiss action received: $id, channelKey: $channelKey');
  }
}
