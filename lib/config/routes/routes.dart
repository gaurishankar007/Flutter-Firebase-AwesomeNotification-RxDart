import 'package:firebase_crud/presentation/screens/home.dart';
import 'package:firebase_crud/presentation/screens/internationalization/product.dart';
import 'package:firebase_crud/presentation/screens/firebase/user.dart';
import 'package:flutter/material.dart';

import '../../presentation/screens/internationalization/internationalization.dart';

class AppRoute {
  static Route? onGenerated(RouteSettings settings) {
    switch (settings.name) {
      case "/home":
        return _materialRoute(Home());

      case "/internationalization":
        return _materialRoute(Internationalization());

      case "/product":
        return _materialRoute(ProductDetail());

      case "/firebase":
        return _materialRoute(AllUsers());

      default:
        return null;
    }
  }

  static Route<dynamic> _materialRoute(Widget page) {
    return MaterialPageRoute(builder: (builder) => page);
  }
}
