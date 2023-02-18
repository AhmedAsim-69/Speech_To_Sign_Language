import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

import 'package:stsl/functions/functions.dart';

class AudioPlay {
  static final audioPlayer = AudioPlayer();

  static bool isPlaying = false;
  static Duration duration = Duration.zero;
  static Duration position = Duration.zero;

  static Future setAudio() async {
    MyFunctions.stopAudio();
    await audioPlayer.dispose();
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    String dir = (await getExternalStorageDirectory())!.path;
    await audioPlayer.setSource(DeviceFileSource("$dir/audio.wav"));

    audioPlayer.onDurationChanged.listen((newDuration) {
      duration = newDuration;
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      position = newPosition;
    });
  }

  static Future playAudio() async {
    String dir = (await getExternalStorageDirectory())!.path;
    await audioPlayer.play(DeviceFileSource("$dir/audio.wav"));
  }
}
