import '../../core/utils/local_notification_service.dart';
import 'package:flutter/material.dart';

Future<bool> showNotificationDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text("Notification Permission"),
        content: const Text("Allow this app to send notification"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              final permission = await LocalNotificationService.requestNotification();
              if (dialogContext.mounted) {
                Navigator.pop(dialogContext, permission);
              }
            },
            child: const Text("Allow"),
          ),
        ],
      );
    },
  );
}
