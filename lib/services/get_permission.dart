import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stsl/pages/homepage.dart';
import 'package:stsl/widgets/snackbar.dart';

class GetPermission {
  static late PermissionStatus microphoneStatus;
  static late PermissionStatus storageStatus;
  static Future<void> goToHome(context) async {
    microphoneStatus = await Permission.microphone.request();
    if (microphoneStatus.isGranted) {
      storageStatus = await Permission.storage.request();
      if (storageStatus.isGranted) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setInt('isBoarding', 0);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else if (storageStatus.isDenied || storageStatus.isRestricted) {
        storageStatus = await Permission.storage.request();
        if (storageStatus.isGranted) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.setInt('isBoarding', 0);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          ShowSnackbar.showsnackbar(
            Colors.black54,
            Colors.orange,
            Icons.warning,
            'Please enable storage permission from Settings',
            context,
          );
          openAppSettings();
        }
      } else if (storageStatus.isPermanentlyDenied) {
        ShowSnackbar.showsnackbar(
          Colors.black54,
          Colors.orange,
          Icons.warning,
          'Please allow storage permission from Settings',
          context,
        );
        openAppSettings();
      }
    } else if (microphoneStatus.isDenied || microphoneStatus.isRestricted) {
      microphoneStatus = await Permission.microphone.request();
      if (microphoneStatus.isGranted) {
        storageStatus = await Permission.storage.request();
        if (storageStatus.isGranted) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.setInt('isBoarding', 0);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          ShowSnackbar.showsnackbar(
            Colors.black54,
            Colors.orange,
            Icons.warning,
            'Please enable storage permission from Settings',
            context,
          );
          openAppSettings();
        }
      } else {
        ShowSnackbar.showsnackbar(
          Colors.black54,
          Colors.orange,
          Icons.warning,
          'Please enable microphone permission from Settings',
          context,
        );
      }
    } else if (microphoneStatus.isPermanentlyDenied) {
      ShowSnackbar.showsnackbar(
        Colors.black54,
        Colors.orange,
        Icons.warning,
        'Please allow microphone permission from Settings',
        context,
      );
      openAppSettings();
    }
  }
}
