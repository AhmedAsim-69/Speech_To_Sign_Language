import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';

class AudioPlay {
  static final audioPlayer = AudioPlayer();

  static bool isPlaying = false;
  static Duration duration = Duration.zero;
  static Duration position = Duration.zero;

  static Future setAudio() async {
    log("init\n");
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    log("plat\n");
    // final speech = File(
    //     '/storage/emulated/0/Android/data/com.example.stsl/files/audio.wav');
    // audioPlayer.setSourceUrl(speech.path);
    // log("playeddd\n");
    // audioPlayer.setSourceUrl('/data/user/0/com.example.stsl/cache/audio');
    // audioPlayer.setSourceUrl(url)
  }
}
