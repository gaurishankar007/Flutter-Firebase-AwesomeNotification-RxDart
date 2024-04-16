import 'package:firebase_crud/main.dart';
import 'package:flutter/material.dart';

showNotificationDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text("Notification Permission"),
        content: const Text("Allow this app to send notification"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await localNotificationService.requestNotification();
            },
            child: const Text("Allow"),
          ),
        ],
      );
    },
  );
}
