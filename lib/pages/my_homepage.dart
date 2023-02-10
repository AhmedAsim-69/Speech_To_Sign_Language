import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
// import 'package:sagae/core/util/image_b64_decoder.dart';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:stsl/services/audio_player.dart';
import 'package:stsl/services/audio_recorder.dart';
import 'package:stsl/services/format_time.dart';
import 'package:stsl/services/upload_file.dart';
import 'package:video_player/video_player.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

String message = "";

class _MyHomePageState extends State<MyHomePage> {
  // Future<VideoPlayerController>? _futureController;
  // VideoPlayerController? _controller;
  // Future<VideoPlayerController> createVideoPlayer() async {
  //   // Uint8List bytes = base64Decode(UploadFile.message);

  //   // final File file = await Image.memory(bytes) as File;
  //   // final File file = await ImgB64Decoder.fileFromB64String(UploadFile.message);
  //   Uint8List bytes = base64.decode(UploadFile.message);
  //   String dir = (await getApplicationDocumentsDirectory()).path;
  //   File file = File(
  //       "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".mp4");
  //   await file.writeAsBytes(bytes);
  //   log("${file.path}");

  //   final VideoPlayerController controller = VideoPlayerController.file(file);
  //   await controller.initialize();
  //   await controller.setLooping(true);
  //   return controller;
  // }

  @override
  void initState() {
    super.initState();
    log("before\n");
    AudioRecorder.initRecorder();
    AudioPlay.setAudio();
    AudioPlay.audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        AudioPlay.isPlaying = state == PlayerState.isPlaying;
      });
    });
    AudioPlay.audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        AudioPlay.duration = newDuration;
      });
    });
    AudioPlay.audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        AudioPlay.position = newPosition;
      });
    });
    log("after\n");
  }

  @override
  void dispose() {
    AudioRecorder.recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<RecordingDisposition>(
              stream: AudioRecorder.recorder.onProgress,
              builder: (context, snapshot) {
                final duration =
                    snapshot.hasData ? snapshot.data!.duration : Duration.zero;
                return Text('${duration.inSeconds} s');
              },
            ),
            ElevatedButton(
              child: Icon(
                AudioRecorder.recorder.isRecording
                    ? Icons.record_voice_over
                    : Icons.mic,
                color: Colors.lightBlue,
              ),
              onPressed: () async {
                if (AudioRecorder.recorder.isRecording) {
                  await AudioRecorder.stopRecording();
                } else {
                  await AudioRecorder.startRecording();
                }
                setState(() {});
              },
            ),
            Slider(
              min: 0,
              max: AudioPlay.duration.inSeconds.toDouble(),
              value: AudioPlay.position.inDays.toDouble(),
              onChanged: ((value) async {
                final position = Duration(seconds: value.toInt());
                await AudioPlay.audioPlayer.seek(position);
                await AudioPlay.audioPlayer.resume();
              }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 1, 2, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    FormatTime.formatTime(AudioPlay.position),
                  ),
                  ElevatedButton(
                    child: Icon(
                      AudioPlay.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.lightBlue,
                    ),
                    onPressed: () async {
                      if (AudioPlay.isPlaying) {
                        await AudioPlay.audioPlayer.pause();
                      } else {
                        await AudioPlay.audioPlayer.resume();
                      }
                      setState(() {});
                    },
                  ),
                  Text(FormatTime.formatTime(AudioPlay.duration)),
                ],
              ),
            ),
            TextButton(
              onPressed: () => UploadFile.uploadFile(),
              child: const Text(
                "Upload Speech",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
