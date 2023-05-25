import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:path_provider/path_provider.dart';

import 'package:stsl/services/api_call.dart';

import 'package:video_player/video_player.dart';

class PoseVideoPlayer {
  static ChewieController? poseController;

  static Future<void> videoController() async {
    Uint8List skeletonData = (ApiCall.skeletonPose == "No Skeleton")
        ? Uint8List(0)
        : base64.decode(ApiCall.skeletonPose);
    var dir = (await getExternalStorageDirectory())!.path;

    File file = File("$dir/Pose.mp4");
    if (skeletonData.isNotEmpty) {
      await file.writeAsBytes(skeletonData);
    }

    final VideoPlayerController poseVideoController =
        VideoPlayerController.file(file);

    poseVideoController.addListener(() {
      if (poseVideoController.value.hasError) {
        log('Video playback error: ${poseVideoController.value.errorDescription}');
      }
    });

    log(" DURATION === ${poseController?.videoPlayerController.value.duration} ");

    var syncPath = "$dir/Pose.mp4";

    bool isFile = io.File(syncPath).existsSync();

    if (isFile) {
      await poseVideoController.initialize();

      poseController?.dispose();
      poseController = ChewieController(
        videoPlayerController: poseVideoController,
        aspectRatio: 4 / 3,
        allowFullScreen: true,
        allowPlaybackSpeedChanging: true,
        fullScreenByDefault: false,
        showControls: true,
        playbackSpeeds: [0.25, 0.5, 0.75, 1, 1.25, 1.50, 1.75, 2],
      );
    }
  }
}
