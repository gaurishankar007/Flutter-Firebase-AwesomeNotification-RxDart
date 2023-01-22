import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crud/presentation/screens/user.dart';
import 'package:firebase_crud/config/theme.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Crud Operation',
      theme: lightTheme,
      home: AllUsers(),
    );
  }
}
