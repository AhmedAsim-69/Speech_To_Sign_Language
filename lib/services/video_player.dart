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
  static ChewieController? chewieController;
  static videoController() async {
    Uint8List bytes = (ApiCall.message == "No Pose Could be made")
        ? Uint8List(0)
        : base64.decode(ApiCall.message);
    var dir = (await getExternalStorageDirectory())!.path;

    File file = File("$dir/STSL.mp4");
    if (bytes.isNotEmpty) {
      await file.writeAsBytes(bytes);
    }
    final VideoPlayerController ccontroller = VideoPlayerController.file(file);
    if (ApiCall.message == "No Pose could be made") {
      chewieController!.dispose();
      return ccontroller;
    }
    var syncPath = "$dir/STSL.mp4";

    await io.File(syncPath).exists();
    bool isFile = io.File(syncPath).existsSync();

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
