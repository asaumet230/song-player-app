import 'package:flutter/material.dart';

class AppTheme {
  static const Color backgroundColor = Color(0xff201E28);

  ThemeData getAppTheme() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      // scaffoldBackgroundColor: Color(0xff40404C),
      brightness: Brightness.dark,
      iconTheme: IconThemeData(
        color: Colors.white.withOpacity(0.3),
      ),
    );
  }
}
