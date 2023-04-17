import 'package:flutter/material.dart';
import 'package:stsl/pages/splashscreen.dart';
import 'package:stsl/services/user_simple_preferences.dart';
import 'package:provider/provider.dart';
import 'package:stsl/utils/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSimplePreferences.init();
  runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => ThemeNotifier(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(builder: (context, theme, _) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pakistan Sign Express',
        theme: theme.getTheme(),
        darkTheme: ThemeData.dark(),
        home: const SplashScreen(),
      );
    });
  }
}
