import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:stsl/pages/speech_page.dart';

import 'package:stsl/services/audio_recorder.dart';

class MyFunctions {
  static File file = File("");
  static final PlayerController controller = PlayerController();
  static late StreamSubscription<PlayerState> playerStateSubscription;

  static Future<void> startRec() async {
    if (!isRec) {
      isRec = true;
      await AudioRecorder.startRecording();
    }
  }

  static Future<void> stopRec() async {
    if (isRec) {
      isRec = false;
      await AudioRecorder.stopRecording();
      await preparePlayer();
    }
  }

  static Future initStorage() async {
    final status = await Permission.storage.request();
    if (status != PermissionStatus.granted) {
      initStorage();
      throw ("Storage permission not granted");
    }
    if (status.isDenied == true) {
      initStorage();
    }
  }

  static Future<File> getFile() async {
    String dir = (await getExternalStorageDirectory())!.path;
    file = File('$dir/audio.wav');
    return file;
  }

  static Future<void> preparePlayer([VoidCallback? updateBubbleFunc]) async {
    String path = (await getExternalStorageDirectory())!.path;
    file = await getFile();
    if (file.existsSync()) {
      controller.preparePlayer(
        path: "$path/audio.wav",
        shouldExtractWaveform: true,
      );
      controller
          .extractWaveformData(
        path: "$path/audio.wav",
      )
          .then((waveformData) {
        debugPrint(waveformData.toString());
      });
    }

    if (updateBubbleFunc != null) {
      updateBubbleFunc();
    }
  }
}
