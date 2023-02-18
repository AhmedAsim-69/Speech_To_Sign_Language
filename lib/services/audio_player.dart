import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stsl/functions/functions.dart';

class AudioPlay {
  static final audioPlayer = AudioPlayer();

  static bool isPlaying = false;
  static Duration duration = Duration.zero;
  static Duration position = Duration.zero;

  static Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    String dir = (await getExternalStorageDirectory())!.path;
    audioPlayer.setSource(DeviceFileSource("$dir/audio.wav"));
    MyFunctions.stopAudio();
    // duration = audioPlayer.getDuration();
    log("DURATIONNNN = $duration");
    audioPlayer.onDurationChanged.listen((newDuration) {
      duration = newDuration;
      log("dur updated = ${AudioPlay.duration}, $newDuration\n");
      // log("IN AUDIO FUNCS 1\n");
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      position = newPosition;
      log("IN AUDIO FUNCS 2\n");
    });

    log("Audio Selected");
  }

  static Future playAudio() async {
    String dir = (await getExternalStorageDirectory())!.path;
    // File file = File("$dir/STSL.mp4");
    await audioPlayer.play(DeviceFileSource("$dir/audio.wav"));
  }
}
