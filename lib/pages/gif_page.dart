import 'package:flutter/material.dart';

import 'dart:async';

import 'package:stsl/services/get_permission.dart';

class GifPage extends StatelessWidget {
  const GifPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      GetPermission.goToHome(context);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: Image.asset(
          'assets/gifs/splashscreen.gif',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
