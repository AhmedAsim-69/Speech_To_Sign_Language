import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

class AudioPlay {
  static final audioPlayer = AudioPlayer();

  static bool isPlaying = false;
  static Duration duration = Duration.zero;
  static Duration position = Duration.zero;

  static Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  static Future playAudio() async {
    String dir = (await getExternalStorageDirectory())!.path;
    // File file = File("$dir/STSL.mp4");
    await audioPlayer.play(DeviceFileSource("$dir/audio.wav"));
  }
}
