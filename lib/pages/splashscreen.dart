import 'package:flutter/material.dart';

import 'package:stsl/services/get_permission.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

bool flag = false;

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    GetPermission.goToHome(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            "Pakistan Sign Express",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      )),
    );
  }
}
