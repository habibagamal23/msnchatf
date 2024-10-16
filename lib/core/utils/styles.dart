import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ColorsManager {
  static const Color mainBlue = Color(0xFF005683);
  static const Color blue2 = Color(0xFF3BB2EA);
  static const Color input = Color(0xFFEDF3F5);
  static const Color lightblue = Color(0xFFD8F3FF);
  static const Color blue = Color(0xFFABE0F5);
  static const Color attenion = Color(0xFFFF3A45);
  static const Color whitebeg = Color(0xFFFDFEFF);

}
class Styles{
 static String formatLastMessageTime(String lastMessageTime) {
    DateTime lastMessageDateTime = DateTime.parse(lastMessageTime);
    DateTime now = DateTime.now();
    if (now.difference(lastMessageDateTime).inDays == 0) {
      return DateFormat.jm().format(lastMessageDateTime);
    } else {
      return DateFormat('MMM dd, yyyy').format(lastMessageDateTime);
    }
  }

  static String getLastActiveTime(String lastActivated) {
    final DateTime lastActiveDate = DateTime.parse(lastActivated);
    final DateTime now = DateTime.now();
    final DateFormat timeFormat = DateFormat.jm();
    final DateFormat dateFormat = DateFormat('MMM d, h:mm a');
    if (lastActiveDate.year == now.year &&
    lastActiveDate.month == now.month &&
        lastActiveDate.day == now.day  ) {
      return 'Today at ${timeFormat.format(lastActiveDate)}';
    } else {
      return dateFormat.format(lastActiveDate);
    }
  }

}

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: ColorsManager.mainBlue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: ColorsManager.whitebeg,
      titleTextStyle: TextStyle(color: ColorsManager.blue2, fontSize: 20),
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 16, color: Colors.black),
      titleLarge: TextStyle(fontSize: 14, color: Colors.grey),
      labelLarge: TextStyle(fontSize: 16, color: ColorsManager.mainBlue),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: ColorsManager.mainBlue,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      color: ColorsManager.mainBlue,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 16, color: Colors.white),
      titleLarge: TextStyle(fontSize: 14, color: Colors.grey),
      labelLarge: TextStyle(fontSize: 16, color: ColorsManager.blue2),
    ),
  );
}
