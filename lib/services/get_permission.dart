import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsl/pages/dashboard.dart';
import 'package:stsl/widgets/snackbar.dart';

class GetPermission {
  static void goToHome(context) async {
    Map<Permission, PermissionStatus> status = await [
      Permission.audio,
      // Permission.manageExternalStorage,
      Permission.microphone,
      Permission.storage,
    ].request();

    // if(status.keys. == true){

    // }
    if (status.toString().contains('PermissionStatus.granted')) {
      // log("${status.entries}");
      // log("${status.keys}");
      // log("${status.values}");
      // status.forEach((key, value) {
      //   log("$key, $value");
      // });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setInt('isBoarding', 0);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
      //   log('+++++++++++${status.toString()}');
      // }
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (_) => const Dashboard()),
      // );
      // if (status.toString() == PermissionStatus.denied) {
      //   ShowSnackbar.showsnackbar(Colors.yellow, Colors.red, Icons.warning,
      //       "All Permissions denied", context);
      // }
    } else {
      ShowSnackbar.showsnackbar(
          Colors.black,
          Colors.white,
          Icons.warning,
          "Please re-open app and/or Enable Permissions from Settings",
          context);
    }
    if (status.toString().contains('PermissionStatus.permanentlyDenied') ||
        status.toString().contains('PermissionStatus.restricted')) {
      ShowSnackbar.showsnackbar(Colors.black, Colors.yellow, Icons.warning,
          "Please enable required Permissions", context);
      log("denieedddd");
      openAppSettings();
    }
  }
}
