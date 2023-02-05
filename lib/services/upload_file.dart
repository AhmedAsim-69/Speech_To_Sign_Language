// import 'dart:convert';
// import 'dart:developer';

// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:http/http.dart' as http;

// class UploadFile {
// //--------------------------------------------//
//   // ///////////////
//   static File? selectedFile;
//   static selectSpeech() async {
//     log("inside selectSpeech\n");
//     final pickedFile = await FilePicker.platform.pickFiles();
//     if (pickedFile != null) {
//       selectedFile = File(pickedFile.files.single.path!);
//     }
//   }

// // ///////////////
//   static String message = "";
//   static String uri = " https://5997-39-46-123-229.in.ngrok.io/upload/";
//   static uploadFile() async {
//     final request = http.MultipartRequest(
//         "POST", Uri.parse("https://5997-39-46-123-229.in.ngrok.io/upload"));
//     final headers = {"Content-type": " multipart/form-data"};
//     request.files.add(http.MultipartFile('speech',
//         selectedFile!.readAsBytes().asStream(), selectedFile!.lengthSync(),
//         filename: selectedFile!.path.split('/').last));

//     request.headers.addAll(headers);
//     final response = await request.send();
//     http.Response res = await http.Response.fromStream(response);
//     final resJson = jsonDecode(res.body);
//     message = resJson['message'];
//     log(message);
//   }
// //--------------------------------------------//
// }
