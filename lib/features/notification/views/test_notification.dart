import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_crud/main.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/notification_time_picker.dart';

class TestNotification extends StatefulWidget {
  final VoidCallback goBack;
  const TestNotification({super.key, required this.goBack});

  @override
  State<TestNotification> createState() => _TestNotificationState();
}

class _TestNotificationState extends State<TestNotification> {
  @override
  void initState() {
    super.initState();

    localNotificationService.setListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: widget.goBack,
          icon: const Icon(Icons.close),
        ),
        title: const Text('Test Notification'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(width: double.maxFinite),
            ElevatedButton(
              onPressed: () {
                localNotificationService.showBasicNotification(
                  channelKey: 'basic_channel',
                  title: 'Hello',
                  body: 'This is a basic notification ${Emojis.smile_face_with_tongue}',
                  imageAssetPath: 'assets/images/mountain.jpg',
                );
              },
              child: const Text('Show Basic Notification'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final schedule = await pickSchedule(context);

                if (schedule != null) {
                  localNotificationService.showReminderNotification(
                    channelKey: 'scheduled_channel',
                    title: 'Hello',
                    body: 'This is a scheduled notification ${Emojis.sun_full_moon_face}',
                    notificationWeekAndTime: schedule,
                  );
                }
              },
              child: const Text('Show Scheduled Notification'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async => localNotificationService.cancelReminderNotifications(),
              child: const Text('Cancel Scheduled Notification'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final notifications = await localNotificationService.getScheduledNotifications();
                debugPrint(notifications.toString());
              },
              child: const Text('Print Scheduled Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
