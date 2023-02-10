import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

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
    await file.writeAsBytes(bytes);
    final VideoPlayerController controller = VideoPlayerController.file(file);
    await controller.initialize();
    await controller.setLooping(true);
    return controller;
  }
}
