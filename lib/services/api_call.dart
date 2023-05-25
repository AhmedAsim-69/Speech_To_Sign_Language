import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stsl/services/sign_video_player.dart';
import 'dart:io';

import 'package:stsl/services/user_simple_preferences.dart';
import 'package:stsl/services/pose_video_player.dart';

import 'package:stsl/widgets/snackbar.dart';

class ApiCall {
  static String humanPose = "";
  static String skeletonPose = "";
  static String wordsFound = "";
  static String wordsNotFound = "";
  static String poseWordsFound = "";
  static bool isFetched = false;
  static bool isLoading = false;

  static Future<void> uploadSpeech(
      File? audio, String? text, bool isAudio, bool isText, bool isPose,
      [VoidCallback? updateState, BuildContext? context]) async {
    isFetched = false;
    isLoading = true;
    if (updateState != null) {
      updateState();
    }

    final request = http.MultipartRequest(
        "POST", Uri.parse("http://192.168.10.8:4000/uploadSpeech"));

    request.fields['isAudio'] = isAudio.toString();
    request.fields['isText'] = isText.toString();
    request.fields['isPose'] = isPose.toString();

    final headers = {
      "Content-type": " multipart/form-data",
      "Connection": "Keep-Alive ",
    };

    if (audio != null) {
      request.files.add(http.MultipartFile(
          'audio', audio.readAsBytes().asStream(), audio.lengthSync(),
          filename: audio.path.split('/').last));
    }

    if (text != null) {
      request.fields['text'] = text;
    }

    request.headers.addAll(headers);
    try {
      final response = await request.send();

      if (response.statusCode >= 200 && (response.statusCode <= 299)) {
        http.Response res = await http.Response.fromStream(response);

        final resJson = jsonDecode(res.body);

        humanPose = resJson["humanPose"];
        skeletonPose = resJson["skeletonPose"];
        wordsFound = resJson["sentence"].toString();
        wordsNotFound = resJson["words_not_found"].toString();
        if (isPose) {
          poseWordsFound = resJson["sentence"].toString();
        }

        isFetched = true;

        await SignVideoPlayer.videoController();
        if (isPose) {
          await PoseVideoPlayer.videoController();
        }
        if (updateState != null) {
          UserSimplePreferences.storeWords(wordsFound);
          UserSimplePreferences.storeNotWords(wordsNotFound);
          if (resJson["humanPose"] == "No Pose Could be made") {
            ShowSnackbar.showsnackbar(Colors.black54, Colors.yellow,
                Icons.warning, "No Pose Could be made.", context!);
          } else if (resJson["skeletonPose"] == "No Skeleton" &&
              isPose == true) {
            ShowSnackbar.showsnackbar(Colors.black54, Colors.yellow,
                Icons.warning, "No Skeleton Could be made.", context!);
          } else {
            ShowSnackbar.showsnackbar(Colors.black54, Colors.green, Icons.done,
                "Sign is available to be played.", context!);
          }
          isLoading = false;
          updateState();
        }
      } else {
        isLoading = false;
        ShowSnackbar.showsnackbar(Colors.black54, Colors.red, Icons.warning,
            "Backend Error.", context!);
        updateState!();
      }
    } on http.ClientException catch (e) {
      isLoading = false;
      updateState!();
      ShowSnackbar.showsnackbar(Colors.black54, Colors.orange, Icons.error,
          'HTTP request failed: $e', context!);
    } catch (e) {
      isLoading = false;
      updateState!();
      ShowSnackbar.showsnackbar(
          Colors.black54, Colors.red, Icons.error, 'Error: $e', context!);
    }
  }
}
