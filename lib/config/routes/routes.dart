import 'package:firebase_crud/presentation/screens/auth/login_register.dart';
import 'package:firebase_crud/presentation/screens/home.dart';
import 'package:flutter/material.dart';


class AppRoute {
  static Route? onGenerated(RouteSettings settings) {
    switch (settings.name) {
      case "/loginRegister":
        return _materialRoute(LoginRegister());

      case "/home":
        return _materialRoute(Home());

      default:
        return null;
    }
  }

  static Route<dynamic> _materialRoute(Widget page) {
    return MaterialPageRoute(builder: (builder) => page);
  }
}
