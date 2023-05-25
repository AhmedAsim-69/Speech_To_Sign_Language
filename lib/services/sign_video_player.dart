import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:path_provider/path_provider.dart';

import 'package:stsl/services/api_call.dart';

import 'package:video_player/video_player.dart';

class SignVideoPlayer {
  static ChewieController? signController;

  static Future<void> videoController() async {
    Uint8List humanData = (ApiCall.humanPose == "No Pose Could be made")
        ? Uint8List(0)
        : base64.decode(ApiCall.humanPose);
    var dir = (await getExternalStorageDirectory())!.path;

    File file = File("$dir/Sign.mp4");
    if (humanData.isNotEmpty) {
      await file.writeAsBytes(humanData);
    }

    final VideoPlayerController signVideoController =
        VideoPlayerController.file(file);

    var syncPath = "$dir/Sign.mp4";

    bool isFile = io.File(syncPath).existsSync();
    if (isFile) {
      await signVideoController.initialize();
      signController?.dispose();
      signController = ChewieController(
        videoPlayerController: signVideoController,
        aspectRatio: 16 / 9,
        allowFullScreen: true,
        allowPlaybackSpeedChanging: true,
        fullScreenByDefault: false,
        showControls: true,
        playbackSpeeds: [0.25, 0.5, 0.75, 1, 1.25, 1.50, 1.75, 2],
      );
    }
  }
}
