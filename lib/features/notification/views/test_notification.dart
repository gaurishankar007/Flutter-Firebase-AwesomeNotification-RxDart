import 'package:awesome_notifications/awesome_notifications.dart';
import '../../../core/utils/local_notification_service.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/notification_time_picker.dart';

class TestNotification extends StatelessWidget {
  final VoidCallback goBack;
  const TestNotification({super.key, required this.goBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: goBack,
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
                LocalNotificationService.showBasicNotification(
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
                  LocalNotificationService.showReminderNotification(
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
              onPressed: () async => LocalNotificationService.cancelReminderNotifications(),
              child: const Text('Cancel Scheduled Notification'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final notifications = await LocalNotificationService.getScheduledNotifications();
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
