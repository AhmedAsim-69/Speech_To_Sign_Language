import 'package:audioplayers/audioplayers.dart';

class AudioPlay {
  static final audioPlayer = AudioPlayer();

  static bool isPlaying = false;
  static Duration duration = Duration.zero;
  static Duration position = Duration.zero;

  static Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.loop);
  }
}
