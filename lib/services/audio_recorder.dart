import 'dart:developer';
import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';

class AudioRecorder {
  static final recorder = FlutterSoundRecorder();
  static bool isRecorderReady = false;
  static const _savPath =
      '/storage/emulated/0/Android/data/com.example.stsl/files/speech.wav';
  static Future startRecording() async {
    final directory = await getExternalStorageDirectory();
    if (!isRecorderReady) return;
    log("started recordin \n");
    await recorder.startRecorder(
        toFile:
            '/storage/emulated/0/Android/data/com.example.stsl/files/audio.wav');
    File name = File(
        '/storage/emulated/0/Android/data/com.example.stsl/files/audio.wav');
    log("The name or path of file is ${name}\n");
  }

  static Future stopRecording() async {
    final directory = await getExternalStorageDirectory();
    log("stopped recordin \n");
    if (!isRecorderReady) return;
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    log("Recorded Audio is in $audioFile \n");
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
