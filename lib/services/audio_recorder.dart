import 'dart:developer';
import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';

class AudioRecorder {
  static final recorder = FlutterSoundRecorder();
  static bool isRecorderReady = false;
  static Future startRecording() async {
    if (!isRecorderReady) return;
    await recorder.startRecorder(
        toFile:
            '/storage/emulated/0/Android/data/com.example.stsl/files/audio.wav');
  }

  static Future stopRecording() async {
    if (!isRecorderReady) return;
  }

  static Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw ("Microphone permission not granted");
    }
    await recorder.openRecorder();
    isRecorderReady = true;
    recorder.setSubscriptionDuration(const Duration(milliseconds: 200));
  }
}
