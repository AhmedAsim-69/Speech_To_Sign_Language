import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:stsl/services/user_simple_preferences.dart';
import 'package:stsl/services/video_player.dart';

import 'package:stsl/widgets/snackbar.dart';

class ApiCall {
  static String message = "";
  static String wordsFound = "";
  static String wordsNotFound = "";
  static bool isFetched = false;
  static bool isLoading = false;

  static Future<void> uploadSpeech(
      [VoidCallback? updateState, BuildContext? context]) async {
    isFetched = false;
    isLoading = true;
    if (updateState != null) {
      updateState();
    }

    File selectedFile = File(
        '/storage/emulated/0/Android/data/com.example.stsl/files/audio.m4a');

    final request = http.MultipartRequest(
        "POST", Uri.parse("http://192.168.10.18:4000/uploadSpeech"));

    final headers = {
      "Content-type": " multipart/form-data",
      "Connection": "Keep-Alive ",
    };

    request.files.add(http.MultipartFile('speech',
        selectedFile.readAsBytes().asStream(), selectedFile.lengthSync(),
        filename: selectedFile.path.split('/').last));

    request.headers.addAll(headers);
    final response = await request.send();

    if (response.statusCode == 200) {
      http.Response res = await http.Response.fromStream(response);

      final resJson = jsonDecode(res.body);

      message = resJson["message"];
      wordsFound = resJson["sentence"].toString();
      wordsNotFound = resJson["words_not_found"].toString();

      isFetched = true;
      LocalVideoPlayer.videoController();

      if (updateState != null) {
        UserSimplePreferences.storeWords(wordsFound);
        UserSimplePreferences.storeNotWords(wordsNotFound);
        if (resJson["message"] == "No Pose Could be made") {
          ShowSnackbar.showsnackbar(Colors.black, Colors.yellow, Icons.warning,
              "No Pose Could be made.", context!);
        } else {
          ShowSnackbar.showsnackbar(Colors.black, Colors.green, Icons.done,
              "Sign is available to be played.", context!);
        }
        isLoading = false;
        updateState();
      }
    } else {
      isLoading = false;
      ShowSnackbar.showsnackbar(
          Colors.black, Colors.red, Icons.warning, "Backend Error.", context!);
      updateState!();
    }
  }

  static Future<void> uploadText(String sentence,
      [VoidCallback? updateState, BuildContext? context]) async {
    isFetched = false;
    isLoading = true;
    if (updateState != null) {
      updateState();
    }

    final request = http.MultipartRequest("POST",
        Uri.parse("http://192.168.10.18:4000/uploadText?text=$sentence"));

    final headers = {
      "Content-type": " multipart/form-data",
      "Connection": "Keep-Alive ",
    };

    request.headers.addAll(headers);
    final response = await request.send();

    if (response.statusCode == 200) {
      http.Response res = await http.Response.fromStream(response);

      final resJson = jsonDecode(res.body);

      message = resJson["message"];
      wordsFound = resJson["sentence"].toString();
      wordsNotFound = resJson["words_not_found"].toString();

      isFetched = true;
      LocalVideoPlayer.videoController();
      isLoading = false;

      if (updateState != null) {
        UserSimplePreferences.storeWords(wordsFound);
        UserSimplePreferences.storeNotWords(wordsNotFound);
        if (resJson["message"] == "No Pose Could be made") {
          ShowSnackbar.showsnackbar(Colors.black, Colors.yellow, Icons.warning,
              "No Pose Could be made.", context!);
        } else {
          ShowSnackbar.showsnackbar(Colors.black, Colors.green, Icons.done,
              "Sign is available to be played.", context!);
          isLoading = false;
          updateState();
        }
      }
    } else {
      isLoading = false;
      ShowSnackbar.showsnackbar(
          Colors.black, Colors.red, Icons.warning, "Backend Error.", context!);
      updateState!();
    }
  }
}
