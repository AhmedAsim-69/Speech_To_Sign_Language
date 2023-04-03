import 'package:flutter/material.dart';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:stsl/functions/functions.dart';

import 'package:stsl/pages/dashboard.dart';

import 'package:stsl/services/api_call.dart';
import 'package:stsl/services/audio_player.dart';
import 'package:stsl/services/audio_recorder.dart';
import 'package:stsl/services/format_time.dart';
import 'package:stsl/services/user_simple_preferences.dart';
import 'package:stsl/services/video_player.dart';

import 'package:stsl/widgets/multi_purpose_button.dart';
import 'package:stsl/widgets/video_button.dart';
import 'package:stsl/widgets/words_container.dart';

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
    MyFunctions.initStorage();
    LocalVideoPlayer.videoController();
    ApiCall.wordsFound = UserSimplePreferences.getWords() ?? "";
    ApiCall.wordsNotFound = UserSimplePreferences.getNotWords() ?? "";
    _audioFuncs();
  }

  @override
  void dispose() {
    AudioRecorder.recorder.closeRecorder();
    if (LocalVideoPlayer.chewieController != null) {
      LocalVideoPlayer.chewieController!.dispose();
    }
    super.dispose();
  }

  void _audioFuncs() {
    // int count = 0;
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
        backgroundColor: Colors.blue[400],
      ),
      body: ModalProgressHUD(
        color: Colors.black,
        opacity: 0.4,
        blur: 1.0,
        progressIndicator: const CircularProgressIndicator(
          color: Colors.red,
          backgroundColor: Colors.yellow,
        ),
        inAsyncCall: ApiCall.isLoading,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              WordsContainer(text: ApiCall.wordsFound, altText: "No Video Yet"),
              WordsContainer(
                  text: ApiCall.wordsNotFound, altText: "No Sentence Yet"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MultiPurposeButton(
                      icon: (!isRec) ? Icons.abc : Icons.phone_paused,
                      function: MyFunctions.startRec,
                      altFunc: MyFunctions.stopAudio,
                      updateFunc: _updateState,
                      bgColor: (!isRec) ? Colors.blue[400] : Colors.blue[100],
                      iconColor: Colors.white,
                      rec: isRec),
                  StreamBuilder<RecordingDisposition>(
                    stream: AudioRecorder.recorder.onProgress,
                    builder: (context, snapshot) {
                      final duration = snapshot.hasData
                          ? snapshot.data!.duration
                          : Duration.zero;
                      return Text(
                        "Recording: ${duration.inSeconds} s",
                        style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 14,
                            fontStyle: FontStyle.italic),
                      );
                    },
                  ),
                  MultiPurposeButton(
                      icon: Icons.stop,
                      function: MyFunctions.stopRec,
                      updateFunc: _updateState,
                      altFunc: AudioPlay.setAudio,
                      altFunc2: _audioFuncs,
                      bgColor: (isRec) ? Colors.red[400] : Colors.red[100],
                      iconColor: Colors.white,
                      rec: isRec),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 2, 15, 2),
                child: Slider(
                  min: 0,
                  max: AudioPlay.duration.inMicroseconds.ceilToDouble(),
                  divisions: 200,
                  value: AudioPlay.position.inMicroseconds.ceilToDouble(),
                  onChanged: ((value) {
                    AudioPlay.audioPlayer
                        .seek(Duration(microseconds: value.toInt()));
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
                      function: MyFunctions.playAudio,
                      updateFunc: _updateState,
                      altFunc: _audioFuncs,
                      bgColor: Colors.blue[400],
                      iconColor: Colors.white,
                    ),
                    MultiPurposeButton(
                        icon: Icons.stop,
                        function: MyFunctions.stopAudio,
                        updateFunc: _updateState,
                        altFunc: _audioFuncs,
                        bgColor: Colors.red[400],
                        iconColor: Colors.white),
                    Text(FormatTime.formatTime(AudioPlay.duration)),
                  ],
                ),
              ),
              TextButton(
                onPressed: () async {
                  await ApiCall.uploadSpeech(_updateState, context);
                },
                child: const Text(
                  "Upload Speech",
                ),
              ),
              const VideoButton(),
            ],
          ),
        ),
      ),
    );
  }
}
