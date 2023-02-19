import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stsl/services/upload_file.dart';
import 'package:video_player/video_player.dart';

class LocalVideoPlayer {
  // static Future<VideoPlayerController>? futureController;
  // static VideoPlayerController? controller;
  // static Future<VideoPlayerController> createVideoPlayer() async {
  //   Uint8List bytes = base64.decode(UploadFile.message);
  //   String dir = (await getExternalStorageDirectory())!.path;
  //   File file = File("$dir/STSL.mp4");
  //   if (bytes.isNotEmpty) {
  //     await file.writeAsBytes(bytes);
  //   }
  //   final VideoPlayerController cntrlr = VideoPlayerController.file(file);
  //   if (cntrlr.value.duration >
  //       const Duration(seconds: 0, minutes: 0, hours: 0)) {
  //     await cntrlr.initialize();
  //     await cntrlr.setLooping(true);
  //     log("in ctrlr");
  //   }
  //   await cntrlr.initialize();
  //   await cntrlr.setLooping(true);
  //   log("ctrlr = ${cntrlr.value.duration}");
  //   log("all done");

  //   return cntrlr;
  // }

  static Future<VideoPlayerController>? videoPlayerController;
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
    await ccontroller.initialize();
    await ccontroller.setLooping(true);
    chewieController = ChewieController(
      videoPlayerController: ccontroller,
      aspectRatio: ccontroller.value.aspectRatio,
      allowFullScreen: true,
      allowPlaybackSpeedChanging: true,
      fullScreenByDefault: false,
      showControls: true,
      playbackSpeeds: [0.25, 0.5, 0.75, 1, 1.25, 1.50, 1.75, 2],
    );
    log("ch = ${ccontroller.value.duration}");
    log("aspect ratio = ${ccontroller.value.aspectRatio}");
    return ccontroller;
  }
}
