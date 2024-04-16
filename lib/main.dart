import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crud/core/utils/local_notification_service.dart';
import 'package:flutter/material.dart';

import 'features/app/views/home.dart';
import 'firebase_options.dart';

final localNotificationService = LocalNotificationService();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await localNotificationService.initializeLocalNotifications(
    channelKey: 'basic_channel',
    channelName: 'Basic Notification',
    channelDescription: 'Basic notification alerts',
    showBadge: true,
  );
  await localNotificationService.initializeLocalNotifications(
    channelKey: 'scheduled_channel',
    channelName: 'Scheduled Notification',
    channelDescription: 'Scheduled notification alerts',
    locked: true,
    soundSource: "resource://raw/res_notification_sound",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase With RxDart',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const Home(),
    );
  }
}
