import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:stsl/pages/speech_page.dart';

import 'package:stsl/services/audio_player.dart';
import 'package:stsl/services/audio_recorder.dart';

class MyFunctions {
  static Future<void> startRec() async {
    if (!isRec && !isPause) {
      isRec = true;
      await AudioRecorder.startRecording();
    } else if (isRec && !isPause) {
      isRec = true;
      isPause = true;
      await AudioRecorder.pauseRecording();
    } else {
      isRec = true;
      isPause = false;
      await AudioRecorder.resumeRecording();
    }
  }

  static Future<void> stopRec() async {
    if (isRec) {
      isRec = false;
      isPause = false;
      await AudioRecorder.stopRecording();
    }
  }

  static Future<void> playAudio() async {
    if (isPlay) {
      await AudioPlay.audioPlayer.pause();
      isPlay = false;
      AudioPlay.isPlaying = false;
    } else {
      await AudioPlay.audioPlayer.resume();
      AudioPlay.isPlaying = true;
      isPlay = true;
    }
  }

  static Future<void> stopAudio() async {
    await AudioPlay.audioPlayer.stop();
    isPlay = false;
  }

  static Future<bool> doesFileExist(String fileName, String extension) async {
    String dir = (await getExternalStorageDirectory())!.path;
    var syncPath = "$dir/$fileName.$extension";
    await io.File(syncPath).exists();
    return io.File(syncPath).existsSync();
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
}
