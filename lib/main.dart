import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'features/app/views/home.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
