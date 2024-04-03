import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_ddd/firebase_options.dart';
import 'config/routes/routes.dart';
import 'config/themes/theme.dart';
import 'data/remote/repositories/firebase_auth_repo.dart';
import 'presentation/screens/auth/login_register.dart';
import 'presentation/screens/home.dart';

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
      title: 'Firebase With DDD',
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
