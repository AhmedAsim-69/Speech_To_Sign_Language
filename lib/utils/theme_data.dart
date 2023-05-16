import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:stsl/services/user_simple_preferences.dart';

class ThemeNotifier with ChangeNotifier {
  final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: const Color(0xFF42a79d),
      secondary: const Color(0xFF42a79d),
    ),
    fontFamily: "GoogleSans",
    primaryTextTheme: GoogleFonts.acmeTextTheme(),
    brightness: Brightness.light,
    backgroundColor: const Color(0xFFF5F5F5),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      color: Color(0xFF42a79d),
      foregroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFFF5F5F5),
    ),
    bottomAppBarColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.black),
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: Colors.black,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      bodyText1: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      bodyText2: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color(0xFF42a79d),
        ),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        color: Colors.grey[400],
      ),
      suffixIconColor: Colors.black,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFF56c1b1),
          width: 0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: const BorderSide(
          color: Color(0xFF56c1b1),
          width: 1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100.0),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.0,
        ),
      ),
      errorStyle: TextStyle(
        backgroundColor: Colors.red.withOpacity(0.1),
        fontSize: 12,
        color: Colors.red,
      ),
      filled: true,
      fillColor: const Color(0xFFF0F0F0),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    ),
    cardColor: const Color(0x00000000),
    dividerColor: Colors.black,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF42a79d),
      foregroundColor: Colors.black,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  final darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: const Color(0xFF42a79d),
      secondary: const Color(0xFF42a79d),
      brightness: Brightness.dark,
    ),
    fontFamily: "GoogleSans",
    primaryTextTheme: GoogleFonts.acmeTextTheme(),
    backgroundColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      color: Color(0xFF42a79d),
      foregroundColor: Color(0xFFF5F5F5),
      iconTheme: IconThemeData(color: Color(0xFFF5F5F5)),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.black,
    ),
    bottomAppBarColor: Colors.black,
    iconTheme: const IconThemeData(color: Color(0xFFF5F5F5)),
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: Color(0xFFF5F5F5),
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        color: Color(0xFFF5F5F5),
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        color: Color(0xFFF5F5F5),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      bodyText1: TextStyle(
        color: Color(0xFFF5F5F5),
        fontSize: 16,
      ),
      bodyText2: TextStyle(
        color: Color(0xFFF5F5F5),
        fontSize: 16,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color(0xFF42a79d),
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          const Color(0xFFF5F5F5),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        color: Colors.grey[400],
      ),
      suffixIconColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFF56c1b1),
          width: 0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: const BorderSide(
          color: Color(0xFF56c1b1),
          width: 1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100.0),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.0,
        ),
      ),
      errorStyle: TextStyle(
        backgroundColor: Colors.red.withOpacity(0.1),
        fontSize: 12,
        color: Colors.red,
      ),
      filled: true,
      fillColor: Colors.black,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    ),
    cardColor: const Color(0xFFF5F5F5),
    dividerColor: const Color(0xFFF5F5F5),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF42a79d),
      foregroundColor: Color(0xFFF5F5F5),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  ThemeData _themeData = ThemeData();
  ThemeData getTheme() => _themeData;

  ThemeNotifier() {
    UserSimplePreferences.readData('themeMode').then((value) {
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
      } else {
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    UserSimplePreferences.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    UserSimplePreferences.saveData('themeMode', 'light');
    notifyListeners();
  }
}
