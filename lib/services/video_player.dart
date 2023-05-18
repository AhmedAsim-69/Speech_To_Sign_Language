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

  static ChewieController? chewieController;
  static ChewieController? chewieController1;

  static void videoController() async {
    Uint8List humanData = (ApiCall.humanPose == "No Pose Could be made")
        ? Uint8List(0)
        : base64.decode(ApiCall.humanPose);
    Uint8List skeletonData = (ApiCall.skeletonPose == "No Skeleton")
        ? Uint8List(0)
        : base64.decode(ApiCall.skeletonPose);
    var dir = (await getExternalStorageDirectory())!.path;

    File file = File("$dir/STSL.mp4");
    File file1 = File("$dir/Pose.mp4");
    if (humanData.isNotEmpty) {
      await file.writeAsBytes(humanData);
    }
    if (skeletonData.isNotEmpty) {
      await file1.writeAsBytes(skeletonData);
    }

    final VideoPlayerController ccontroller = VideoPlayerController.file(file);
    final VideoPlayerController ccontroller1 =
        VideoPlayerController.file(file1);

    if (ApiCall.humanPose == "No Pose could be made" &&
        chewieController != null) {
      chewieController!.dispose();
    }

    if (ApiCall.skeletonPose == "No Skeleton" && chewieController1 != null) {
      chewieController1!.dispose();
    }

    var syncPath = "$dir/STSL.mp4";
    var syncPath1 = "$dir/Pose.mp4";

    await io.File(syncPath).exists();
    bool isFile = io.File(syncPath).existsSync();
    await io.File(syncPath1).exists();
    bool isFile1 = io.File(syncPath1).existsSync();

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
    if (isFile1) {
      await ccontroller1.initialize();
      await ccontroller1.setLooping(true);

      chewieController1 = ChewieController(
        videoPlayerController: ccontroller1,
        aspectRatio: ccontroller1.value.aspectRatio,
        allowFullScreen: true,
        allowPlaybackSpeedChanging: true,
        fullScreenByDefault: false,
        showControls: true,
        playbackSpeeds: [0.25, 0.5, 0.75, 1, 1.25, 1.50, 1.75, 2],
      );
    }
  }
}
