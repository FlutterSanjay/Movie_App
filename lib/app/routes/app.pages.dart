import 'package:flutter/material.dart';
import 'app.routes.dart';

abstract class AppPages {
  AppPages._();

  static final Map<String, WidgetBuilder> pages = {
    // Routes.splash: (context) => const SplashView(),
  };
}
