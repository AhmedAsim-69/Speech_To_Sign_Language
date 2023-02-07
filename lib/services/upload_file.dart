import 'dart:convert';
import 'dart:developer';

import 'dart:io';
import 'package:http/http.dart' as http;

class UploadFile {
  static uploadFile() async {
    log("inside function\n");
    File selectedFile = File(
        '/storage/emulated/0/Android/data/com.example.stsl/files/audio.wav');
    log("file selected\n");
    String message = "";
    // String uri = " https://5997-39-46-123-229.in.ngrok.io/upload/";
    // final request =
    //     http.MultipartRequest("POST", Uri.parse("http://10.0.2.2:4000/upload")); //FOR AVD
    final request = http.MultipartRequest(
        "POST", Uri.parse("http://10.0.2.2:4000/upload")); //FOR Physical Mobile
    final headers = {"Content-type": " multipart/form-data"};
    request.files.add(http.MultipartFile('speech',
        selectedFile.readAsBytes().asStream(), selectedFile.lengthSync(),
        filename: selectedFile.path.split('/').last));
    log("After header\n");
    request.headers.addAll(headers);
    log("after request header\n");
    final response = await request.send();
    log("after response\n");
    http.Response res = await http.Response.fromStream(response);
    log("after http respone\n");
    final resJson = jsonDecode(res.body);
    log("After json\n");
    message = resJson['message'];
    log(message);
  }
}
