import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:stsl/services/video_player.dart';
import 'package:stsl/widgets/snackbar.dart';

class UploadFile {
  static String message = "";
  static String sentence = "";
  static String wordsNotFound = "";
  static bool isFetched = false;

  static uploadFile() async {
    isFetched = false;
    File selectedFile = File(
        '/storage/emulated/0/Android/data/com.example.stsl/files/audio.wav');

    final request = http.MultipartRequest(
        "POST", Uri.parse("https://5c01-39-46-123-229.in.ngrok.io/upload"));

    final headers = {
      "Content-type": " multipart/form-data",
      "Connection": "Keep-Alive"
    };

    request.files.add(http.MultipartFile('speech',
        selectedFile.readAsBytes().asStream(), selectedFile.lengthSync(),
        filename: selectedFile.path.split('/').last));

    request.headers.addAll(headers);
    final response = await request.send();

    http.Response res = await http.Response.fromStream(response);
    final resJson = jsonDecode(res.body);

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
  }
}
