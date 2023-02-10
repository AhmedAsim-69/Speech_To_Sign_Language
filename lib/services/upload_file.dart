import 'dart:convert';
import 'dart:developer';

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class UploadFile {
  static String message = "";
  static uploadFile() async {
    log("inside function\n");
    File selectedFile = File(
        '/storage/emulated/0/Android/data/com.example.stsl/files/audio.wav');
    log("file selected\n");
    // String uri = " https://5997-39-46-123-229.in.ngrok.io/upload/";
    // final request =
    //     http.MultipartRequest("POST", Uri.parse("http://10.0.2.2:4000/upload")); //FOR AVD
    final request = http.MultipartRequest(
        "POST", Uri.parse("http://10.0.2.2:4000/upload")); //FOR Physical Mobile
    final headers = {
      "Content-type": " multipart/form-data",
      "Connection": "Keep-Alive"
    };
    // final headers = {"Content-type": "application/json"};
    request.files.add(http.MultipartFile('speech',
        selectedFile.readAsBytes().asStream(), selectedFile.lengthSync(),
        filename: selectedFile.path.split('/').last));
    log("After header\n");
    // Audio
    request.headers.addAll(headers);
    log("after request header\n");
    final response = await request.send();

    log("after response ${response.headers}\n");
    http.Response res = await http.Response.fromStream(response);
    log("after http respone\n");
    // log(res.body);
    // base64Decode(res.body);

    // String imageStr = json.decode(res.body)["img"].toString();
    // Image.memory(base64Decode(imageStr));
    final resJson = jsonDecode(res.body);
    // log("After json\n");
    message = resJson['message'];
    // log("123, $message\n");
    createVideoPlayer();
    // log('${res.request}');
  }

  // Future<VideoPlayerController>? _futureController;
  // VideoPlayerController? _controller;
  static Future<VideoPlayerController> createVideoPlayer() async {
    // Uint8List bytes = base64Decode(UploadFile.message);

    // final File file = await Image.memory(bytes) as File;
    // final File file = await ImgB64Decoder.fileFromB64String(UploadFile.message);
    Uint8List bytes = base64.decode(UploadFile.message);
    String dir = (await getExternalStorageDirectory())!.path;
    File file = File("$dir/STSL.mp4");
    await file.writeAsBytes(bytes);
    log(file.path);

    final VideoPlayerController controller = VideoPlayerController.file(file);
    // await controller.initialize();
    // await controller.setLooping(true);
    return controller;
  }
}
