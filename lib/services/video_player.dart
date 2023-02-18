import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stsl/services/upload_file.dart';
import 'package:video_player/video_player.dart';

class LocalVideoPlayer {
  static Future<VideoPlayerController>? futureController;
  static VideoPlayerController? controller;
  static Future<VideoPlayerController> createVideoPlayer() async {
    Uint8List bytes = base64.decode(UploadFile.message);
    String dir = (await getExternalStorageDirectory())!.path;
    File file = File("$dir/STSL.mp4");
    if (bytes.isNotEmpty) {
      await file.writeAsBytes(bytes);
    }
    final VideoPlayerController cntrlr = VideoPlayerController.file(file);
    if (cntrlr.value.position !=
        const Duration(seconds: 0, minutes: 0, hours: 0)) {
      await cntrlr.initialize();
      await cntrlr.setLooping(true);
    }

    return cntrlr;
  }

  VideoPlayerController? videoPlayerController;
  static ChewieController? chewieController;
  static videoController() async {
    Uint8List bytes = base64.decode(UploadFile.message);
    String dir = (await getExternalStorageDirectory())!.path;
    File file = File("$dir/STSL.mp4");
    if (bytes.isNotEmpty) {
      await file.writeAsBytes(bytes);
    }
    final VideoPlayerController ccontroller = VideoPlayerController.file(file);
    if (ccontroller.value.position !=
        const Duration(seconds: 0, minutes: 0, hours: 0)) {
      await ccontroller.initialize();
      await ccontroller.setLooping(true);
      chewieController = ChewieController(videoPlayerController: ccontroller);
    }
    return ccontroller;
  }
}
