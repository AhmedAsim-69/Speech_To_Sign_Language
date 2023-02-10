import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:stsl/services/video_player.dart';

class UploadFile {
  static String message = "";
  static uploadFile() async {
    File selectedFile = File(
        '/storage/emulated/0/Android/data/com.example.stsl/files/audio.wav');
    final request =
        http.MultipartRequest("POST", Uri.parse("http://10.0.2.2:4000/upload"));
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
    message = resJson['message'];
    LocalVideoPlayer.createVideoPlayer();
  }
}
