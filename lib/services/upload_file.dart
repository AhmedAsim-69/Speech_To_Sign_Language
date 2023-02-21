import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stsl/services/video_player.dart';
import 'package:stsl/widgets/snackbar.dart';

class UploadFile {
  static String message = "";
  static String sentence = "";
  static String wordsNotFound = "";
  static bool isFetched = false;
  static bool isLoading = false;

  static Future<void> uploadFile(
      [VoidCallback? updateState, BuildContext? context]) async {
    isFetched = false;
    isLoading = true;
    if (updateState != null) {
      log("state updated 1");
      updateState();
    }
    log("in upload file\n");
    File selectedFile = File(
        '/storage/emulated/0/Android/data/com.example.stsl/files/audio.wav');

    final request = http.MultipartRequest(
        "POST", Uri.parse("https://6215-39-46-32-46.eu.ngrok.io/upload"));

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
      log("OK!, Status Code1 = ${response.statusCode}");
      http.Response res = await http.Response.fromStream(response);
      log("OK!, Status Code2 = ${response.statusCode}");
      final resJson = jsonDecode(res.body);
      log("OK!, Status Code3 = ${response.statusCode}");

      message = resJson["message"];
      sentence = resJson["sentence"].toString();
      wordsNotFound = resJson["words_not_found"].toString();

      log("${resJson["message"]}");
      log("Combined Sentence  = $sentence");
      log("Words Not Found = $wordsNotFound");

      isFetched = true;
      // LocalVideoPlayer.futureController = LocalVideoPlayer.createVideoPlayer();
      // LocalVideoPlayer.videoPlayerController = LocalVideoPlayer.videoController();
      // LocalVideoPlayer.createVideoPlayer();
      LocalVideoPlayer.videoController();
      isLoading = false;

      if (updateState != null) {
        log("state updated 2");
        updateState();
        ShowSnackbar.showsnackbar(Colors.black, Colors.green, Icons.done,
            "Sign is available to be played.", context!);
      }
    } else {
      log("Not OK! Status Code = ${response.statusCode} ");
      isLoading = false;
      ShowSnackbar.showsnackbar(
          Colors.black, Colors.red, Icons.warning, "Backend Error.", context!);
    }
  }
}
