import 'package:flutter/material.dart';

import 'dart:developer';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:stsl/pages/display_video.dart';

import 'package:stsl/functions/functions.dart';
import 'package:stsl/services/audio_player.dart';
import 'package:stsl/services/audio_recorder.dart';
import 'package:stsl/services/format_time.dart';
import 'package:stsl/services/upload_file.dart';
import 'package:stsl/services/video_player.dart';
import 'package:stsl/widgets/multi_purpose_button.dart';

bool isRec = false;
bool isPlay = false;

class SpeechPage extends StatefulWidget {
  const SpeechPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SpeechPage> createState() => _SpeechPageState();
}

class _SpeechPageState extends State<SpeechPage> {
  @override
  void initState() {
    super.initState();

    AudioRecorder.initRecorder();
    AudioPlay.setAudio();
    // LocalVideoPlayer.createVideoPlayer();
    LocalVideoPlayer.videoController();
    _audioFuncs();
  }

  @override
  void dispose() {
    AudioRecorder.recorder.closeRecorder();
    // LocalVideoPlayer.controller!.dispose();
    // LocalVideoPlayer.chewieController!.dispose();
    super.dispose();
  }

  void _audioFuncs() {
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
  }

  void _updateState() {
    setState(() {});
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            StreamBuilder<RecordingDisposition>(
              stream: AudioRecorder.recorder.onProgress,
              builder: (context, snapshot) {
                log("12333 $isRec");
                final duration =
                    snapshot.hasData ? snapshot.data!.duration : Duration.zero;
                return Text('${duration.inSeconds} s');
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MultiPurposeButton(
                    icon: Icons.abc,
                    function: MyFunctions.startRec,
                    altFunc: MyFunctions.stopAudio,
                    updateFunc: _updateState,
                    bgColor: (!isRec) ? Colors.red : Colors.red[100],
                    iconColor: Colors.white,
                    rec: isRec),
                MultiPurposeButton(
                    icon: Icons.stop,
                    function: MyFunctions.stopRec,
                    updateFunc: _updateState,
                    altFunc: AudioPlay.setAudio,
                    altFunc2: _audioFuncs,
                    bgColor: (isRec) ? Colors.green : Colors.green[100],
                    iconColor: Colors.white,
                    rec: isRec),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 2, 15, 2),
              child: Slider(
                min: 0,
                max: AudioPlay.duration.inMicroseconds.toDouble(),
                divisions: 200,
                value: AudioPlay.position.inMicroseconds.toDouble(),
                onChanged: ((value) {
                  final position = Duration(microseconds: value.toInt());
                  AudioPlay.audioPlayer.seek(position);
                  // AudioPlay.audioPlayer.resume();
                  // setState(() {});
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 1, 2, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    FormatTime.formatTime(AudioPlay.position),
                  ),
                  MultiPurposeButton(
                    icon: (isPlay) ? Icons.pause : Icons.play_arrow,
                    altIcon: Icons.pause,
                    function: MyFunctions.playAudio,
                    updateFunc: _updateState,
                    altFunc: _audioFuncs,
                    iconColor: Colors.white,
                  ),
                  MultiPurposeButton(
                      icon: Icons.stop,
                      function: MyFunctions.stopAudio,
                      updateFunc: _updateState,
                      altFunc: _audioFuncs,
                      bgColor: Colors.red,
                      iconColor: Colors.white),
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
            Text((UploadFile.sentence == "")
                ? "No Video Yet"
                : "The video is formed for: ${UploadFile.sentence}"),
            Text((UploadFile.sentence == "")
                ? "No Sentence Yet"
                : "No Pose found for following words: ${UploadFile.wordsNotFound}"),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DisplayVideo()),
                  );
                });
              },
              child: const Text('Play Video!'),
            ),
          ],
        ),
      ),
    );
  }
}
