import 'dart:developer';
import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';

class AudioRecorder {
  static final recorder = FlutterSoundRecorder();
  static bool isRecorderReady = false;
  static const _savPath =
      '/storage/emulated/0/com.example.stsl123/files/speech.wav';
  static Future startRecording() async {
    if (!isRecorderReady) return;
    log("started recordin \n");
    await recorder.startRecorder(toFile: _savPath);
  }

  static Future stopRecording() async {
    log("stopped recordin \n");
    if (!isRecorderReady) return;
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    log("Recorded Audio is in $audioFile \n");
    final directory = await getExternalStorageDirectory();
    log("Recorded haha is in ${directory!.path} \n");
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
