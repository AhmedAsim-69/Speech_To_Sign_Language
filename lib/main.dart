import 'package:flutter/material.dart';
import 'package:stsl/pages/splashscreen.dart';
import 'package:stsl/services/user_simple_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSimplePreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(255, 79, 168, 197),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
