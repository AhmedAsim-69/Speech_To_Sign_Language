import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stsl/pages/speech_page.dart';

import 'package:stsl/widgets/snackbar.dart';

class GetPermission {
  static void goToHome(context) async {
    Map<Permission, PermissionStatus> status = await [
      Permission.audio,
      Permission.microphone,
      Permission.storage,
    ].request();

    if (status.toString().contains('PermissionStatus.granted')) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setInt('isBoarding', 0);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SpeechPage()),
      );
    } else {
      ShowSnackbar.showsnackbar(
          Colors.black54,
          Colors.orange,
          Icons.warning,
          '''Please re-open app and/or 
          Enable Permissions from Settings''',
          context);
    }
    if (status.toString().contains('PermissionStatus.permanentlyDenied') ||
        status.toString().contains('PermissionStatus.restricted')) {
      ShowSnackbar.showsnackbar(Colors.black54, Colors.orange, Icons.warning,
          "Please enable required Permissions", context);

      openAppSettings();
    }
  }
}
