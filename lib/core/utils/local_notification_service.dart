import 'dart:developer';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_crud/core/utils/notification_time_picker.dart';
import 'package:firebase_crud/core/utils/unique_id.dart';
import 'package:flutter/material.dart' show Colors;

class LocalNotificationService {
  static final AwesomeNotifications _awesomeNotifications = AwesomeNotifications();

  Future<void> initializeLocalNotifications({
    required String channelKey,
    required String channelName,
    required String channelDescription,
    bool showBadge = false,
    bool locked = false,
    String? soundSource,
  }) async {
    await _awesomeNotifications.initialize(
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

  Future<bool> isNotificationAllowed() => _awesomeNotifications.isNotificationAllowed();
  Future<bool> requestNotification() =>
      _awesomeNotifications.requestPermissionToSendNotifications();

  Future<void> showBasicNotification({
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

    await _awesomeNotifications.createNotification(content: notificationContent);
  }

  Future<void> showReminderNotification({
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
        wakeUpScreen: true);

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

    await _awesomeNotifications.createNotification(
      content: notificationContent,
      actionButtons: actionButtons,
      schedule: schedule,
    );
  }

  Future<void> cancelReminderNotifications() async {
    await _awesomeNotifications.cancelAllSchedules();
  }

  Future<List<NotificationModel>> getScheduledNotifications() async {
    return await _awesomeNotifications.listScheduledNotifications();
  }

  setListener() async {
    await _awesomeNotifications.setListeners(
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

  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    int? id = receivedAction.id;
    String? channelKey = receivedAction.channelKey;
    log('Action received: $id, channelKey: $channelKey');

    // Removing the badge count on iOS app icon
    if (Platform.isIOS) {
      final badgeCount = await _awesomeNotifications.getGlobalBadgeCounter();
      if (badgeCount > 0) {
        await _awesomeNotifications.setGlobalBadgeCounter(badgeCount - 1);
      }
    }
  }

  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    int? id = receivedAction.id;
    String? channelKey = receivedAction.channelKey;
    log('Dismiss action received: $id, channelKey: $channelKey');
  }
}
