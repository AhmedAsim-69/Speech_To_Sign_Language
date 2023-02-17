import 'package:stsl/pages/speech_page.dart';
import 'package:stsl/services/audio_recorder.dart';

class MyFunctions {
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
    }
  }
}
