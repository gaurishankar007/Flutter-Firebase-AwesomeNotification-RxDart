import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crud/config/routes/routes.dart';
import 'package:firebase_crud/config/themes/theme.dart';
import 'package:firebase_crud/data/remote/repositories/firebase_auth_repo.dart';
import 'package:firebase_crud/presentation/screens/auth/login_register.dart';
import 'package:firebase_crud/presentation/screens/home.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Crud Operation',
      theme: lightTheme,
      home: StreamBuilder(
        stream: AuthFirebase().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Home();
          } else {
            return const LoginRegister();
          }
        },
      ),
      onGenerateRoute: AppRoute.onGenerated,
    );
  }
}
