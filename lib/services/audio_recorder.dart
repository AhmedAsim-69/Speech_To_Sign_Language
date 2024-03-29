import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorder {
  static final recorder = FlutterSoundRecorder();
  static bool isRecorderReady = false;

  static Future startRecording() async {
    if (!isRecorderReady) return;
    final path = (await (getExternalStorageDirectory()))!.path;
    await recorder.startRecorder(toFile: '$path/audio.wav');
  }

  static Future stopRecording() async {
    if (!isRecorderReady) return;
    await recorder.stopRecorder();
  }

  static Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      initRecorder();
      throw ("Microphone permission not granted");
    } else if (status.isDenied || status.isRestricted) {
      initRecorder();
    }
    await recorder.openRecorder();
    recorder.setSubscriptionDuration(const Duration(milliseconds: 200));
    isRecorderReady = true;
  }
}
