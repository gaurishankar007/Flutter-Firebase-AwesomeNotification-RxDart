import 'package:flutter/material.dart';

import '../../presentation/screens/auth/login_register.dart';
import '../../presentation/screens/home.dart';

class AppRoute {
  static Route? onGenerated(RouteSettings settings) {
    switch (settings.name) {
      case "/loginRegister":
        return _materialRoute(const LoginRegister());

      case "/home":
        return _materialRoute(const Home());

      default:
        return null;
    }
  }

  static Route<dynamic> _materialRoute(Widget page) {
    return MaterialPageRoute(builder: (builder) => page);
  }
}
