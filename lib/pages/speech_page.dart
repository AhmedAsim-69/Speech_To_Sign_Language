import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:stsl/functions/functions.dart';
import 'package:stsl/services/audio_player.dart';
import 'package:stsl/services/audio_recorder.dart';
import 'package:stsl/services/format_time.dart';
import 'package:stsl/services/upload_file.dart';
import 'package:stsl/services/video_player.dart';
import 'package:stsl/widgets/multi_purpose_button.dart';
import 'package:stsl/widgets/snackbar.dart';
import 'package:video_player/video_player.dart';

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
    _audioFuncs();
    // AudioPlay.audioPlayer.onPlayerStateChanged.listen((state) {
    //   setState(() {
    //     AudioPlay.isPlaying = state == PlayerState.isPlaying;
    //     log("INIT IS_PLAYING = ${AudioPlay.isPlaying}");
    //   });
    // });
    // AudioPlay.audioPlayer.onDurationChanged.listen((newDuration) {
    //   setState(() {
    //     AudioPlay.duration = newDuration;
    //   });
    // });
    // AudioPlay.audioPlayer.onPositionChanged.listen((newPosition) {
    //   setState(() {
    //     AudioPlay.position = newPosition;
    //   });
    // });
    // LocalVideoPlayer.futureController = LocalVideoPlayer.createVideoPlayer();
  }

  // Future<void> startRec() async {
  //   if (!isRec) {
  //     isRec = true;
  //     await AudioRecorder.startRecording();
  //   }
  // }

  // Future<void> stopRec() async {
  //   if (isRec) {
  //     isRec = false;
  //     await AudioRecorder.stopRecording();
  //   }
  // }

  @override
  void dispose() {
    AudioRecorder.recorder.closeRecorder();
    LocalVideoPlayer.controller!.dispose();
    super.dispose();
  }

  void _audioFuncs() {
    // log("IN AUDIO FUNCS\n");
    AudioPlay.audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        AudioPlay.duration = newDuration;
        // log("IN AUDIO FUNCS 1\n");
      });
    });
    AudioPlay.audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        AudioPlay.position = newPosition;
        // log("IN AUDIO FUNCS 2\n");
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
          mainAxisAlignment: MainAxisAlignment.center,
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
                max: AudioPlay.duration.inSeconds.toDouble(),
                value: AudioPlay.position.inSeconds.toDouble(),
                onChanged: ((value) {
                  final position = Duration(seconds: value.toInt());
                  AudioPlay.audioPlayer.seek(position);
                  AudioPlay.audioPlayer.resume();
                  setState(() {});
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

                  // ElevatedButton(
                  //   child: Icon(
                  //     AudioPlay.isPlaying ? Icons.pause : Icons.play_arrow,
                  //     color: Colors.lightBlue,
                  //   ),
                  //   onPressed: () async {
                  //     if (AudioPlay.isPlaying) {
                  //       await AudioPlay.audioPlayer.pause();
                  //       AudioPlay.isPlaying = false;
                  //       log("paused");
                  //     } else {
                  //       await AudioPlay.audioPlayer.resume();
                  //       AudioPlay.isPlaying = true;
                  //       log("audioplayer = ${AudioPlay.isPlaying}");
                  //       // log("resumed");
                  //     }
                  //     setState(() {});
                  //   },
                  // ),
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
            Expanded(
              child: FutureBuilder(
                future: LocalVideoPlayer.futureController,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    LocalVideoPlayer.controller =
                        snapshot.data as VideoPlayerController;
                    return Column(
                      children: [
                        AspectRatio(
                          aspectRatio: (16 / 9),
                          child: VideoPlayer(LocalVideoPlayer.controller!),
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            setState(() {
                              if (UploadFile.isFetched == true) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  showsnackbar(Colors.black, UploadFile.message,
                                      context),
                                );
                              }
                              if (LocalVideoPlayer
                                  .controller!.value.isPlaying) {
                                LocalVideoPlayer.controller!.pause();
                              } else {
                                LocalVideoPlayer.controller!.play();
                              }
                            });
                          },
                          backgroundColor:
                              const Color.fromARGB(255, 79, 168, 197),
                          foregroundColor: Colors.black,
                          child: Icon(
                            LocalVideoPlayer.controller!.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                        )
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
