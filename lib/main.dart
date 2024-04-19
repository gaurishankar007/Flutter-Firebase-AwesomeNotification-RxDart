import 'package:firebase_core/firebase_core.dart';
import 'core/utils/firebase_notification_service.dart';
import 'core/utils/local_notification_service.dart';
import 'package:flutter/material.dart';

import 'features/app/views/home.dart';
import 'firebase_options.dart';

Future main() async {
  await initializeApp();
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
      navigatorKey: navigatorKey,
      home: const Home(),
    );
  }
}

initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize local notifications
  await LocalNotificationService.initializeLocalNotifications(
    channelKey: 'basic_channel',
    channelName: 'Basic Notification',
    channelDescription: 'Basic notification alerts',
    showBadge: true,
  );
  await LocalNotificationService.initializeLocalNotifications(
    channelKey: 'scheduled_channel',
    channelName: 'Scheduled Notification',
    channelDescription: 'Scheduled notification alerts',
    locked: true,
    soundSource: "resource://raw/res_notification_sound",
  );
  // Initialize Firebase notifications
  await FirebaseNotificationService.initializeFirebaseNotifications();
  // await LocalNotificationService.initializeIsolateReceivePort();
  await LocalNotificationService.getInitialNotificationAction();
}

final navigatorKey = GlobalKey<NavigatorState>();
