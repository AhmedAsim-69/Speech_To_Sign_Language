import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:path_provider/path_provider.dart';

import 'package:stsl/services/api_call.dart';

import 'package:video_player/video_player.dart';

class LocalVideoPlayer {
  static Future<VideoPlayerController>? videoPlayerController;
  static Future<VideoPlayerController>? videoPlayerController1;
  static Future<VideoPlayerController>? videoPlayerController2;
  static ChewieController? chewieController;
  static ChewieController? chewieController1;
  static ChewieController? chewieController2;
  static videoController() async {
    Uint8List bytes = (ApiCall.message == "No Pose Could be made")
        ? Uint8List(0)
        : base64.decode(ApiCall.message);
    var dir = (await getExternalStorageDirectory())!.path;

    File file = File("$dir/STSL.mp4");
    File file1 = File("$dir/ActualPose.mp4");
    File file2 = File("$dir/PredictedPose.mp4");
    if (bytes.isNotEmpty) {
      await file.writeAsBytes(bytes);
    }
    if (bytes.isNotEmpty) {
      await file1.writeAsBytes(bytes);
    }
    if (bytes.isNotEmpty) {
      await file2.writeAsBytes(bytes);
    }
    final VideoPlayerController ccontroller = VideoPlayerController.file(file);
    final VideoPlayerController ccontroller1 =
        VideoPlayerController.file(file1);
    final VideoPlayerController ccontroller2 =
        VideoPlayerController.file(file2);
    if (ApiCall.message == "No Pose could be made") {
      chewieController!.dispose();
      chewieController1!.dispose();
      chewieController2!.dispose();
      return ccontroller;
    }
    var syncPath = "$dir/STSL.mp4";
    var syncPath1 = "$dir/ActualPose.mp4";
    var syncPath2 = "$dir/PredictedPose.mp4";

    await io.File(syncPath).exists();
    bool isFile = io.File(syncPath).existsSync();
    await io.File(syncPath1).exists();
    bool isFile1 = io.File(syncPath1).existsSync();
    await io.File(syncPath2).exists();
    bool isFile2 = io.File(syncPath2).existsSync();

    if (isFile) {
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
    }

    return ccontroller;
  }
}
