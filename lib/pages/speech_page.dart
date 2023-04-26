import 'dart:developer';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:stsl/functions/functions.dart';

import 'package:stsl/services/api_call.dart';
import 'package:stsl/services/audio_player.dart';
import 'package:stsl/services/audio_recorder.dart';
import 'package:stsl/services/chat_bubble.dart';
import 'package:stsl/services/user_simple_preferences.dart';
import 'package:stsl/services/video_player.dart';

import 'package:stsl/utils/theme_data.dart';

import 'package:stsl/widgets/video_button.dart';
import 'package:stsl/widgets/words_container.dart';

class SpeechPage extends StatefulWidget {
  const SpeechPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SpeechPage> createState() => _SpeechPageState();
}

class _SpeechPageState extends State<SpeechPage> {
  final RecorderController recorderController = RecorderController();

  String? path;
  String? musicFile;
  bool isRecording = false;
  bool isRecordingCompleted = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // AudioRecorder.initRecorder();
    // AudioPlay.setAudio();
    MyFunctions.initStorage();
    LocalVideoPlayer.videoController();
    ApiCall.wordsFound = UserSimplePreferences.getWords() ?? "";
    ApiCall.wordsNotFound = UserSimplePreferences.getNotWords() ?? "";
    _audioFuncs();
    _initialiseControllers();
    _getDir();
  }

  @override
  void dispose() {
    AudioRecorder.recorder.closeRecorder();
    if (LocalVideoPlayer.chewieController != null) {
      LocalVideoPlayer.chewieController!.dispose();
    }
    super.dispose();
  }

  void _startOrStopRecording() async {
    try {
      if (isRecording) {
        recorderController.reset();
        final path = await recorderController.stop();

        log("recording stopppeeeddd!!!");

        if (path != null) {
          isRecordingCompleted = true;
          log("Recorded file size: ${File(path).lengthSync()}");
          log(path);
          log("IS RECORDING COMPLETED = $isRecordingCompleted");
          _updateState();
          // AudioPlay.setAudio();
        }
      } else {
        // await recorderController.record();
        await recorderController.record(
            path:
                '/storage/emulated/0/Android/data/com.example.stsl/files/audio.m4a');
        log("file path is $path");
      }
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        isRecording = !isRecording;
        _updateState();
      });
    }
  }

  void _refreshWave() {
    if (isRecording) {
      log("before");
      recorderController.refresh();
      log("refreshed");
    }
  }

  void _getDir() async {
    path = "${(await getExternalStorageDirectory())!.path}/audio.m4a";
    isLoading = false;
    setState(() {
      log("path = $path");
    });
  }

  void _initialiseControllers() {
    recorderController
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      musicFile = result.files.single.path;
      setState(() {});
    } else {
      log("File not picked");
    }
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
    return Consumer<ThemeNotifier>(builder: (context, theme, _) {
      return Scaffold(
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
                WordsContainer(
                    text: ApiCall.wordsFound,
                    altText: "No Video Yet",
                    poseText: "Pose Found for the following words: "),
                WordsContainer(
                    text: ApiCall.wordsNotFound,
                    altText: "No Sentence Yet",
                    poseText: "Pose Not Found for the following words: "),
                TextButton(
                  onPressed: () async {
                    await ApiCall.uploadSpeech(_updateState, context);
                  },
                  child: const Text(
                    "Upload Speech",
                  ),
                ),
                const VideoButton(),
                if (isRecordingCompleted) const WaveBubble(),
                if (musicFile != null) const WaveBubble(),
                SafeArea(
                  child: Row(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: isRecording
                            ? AudioWaveforms(
                                enableGesture: true,
                                size: Size(
                                    MediaQuery.of(context).size.width / 2, 50),
                                recorderController: recorderController,
                                waveStyle: const WaveStyle(
                                  waveColor: Colors.white,
                                  extendWaveform: true,
                                  showMiddleLine: false,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: const Color(0xFF1E1B26),
                                ),
                                padding: const EdgeInsets.only(left: 18),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width / 1.7,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E1B26),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                padding: const EdgeInsets.only(left: 18),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: TextField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    hintText: "Type Something...",
                                    hintStyle:
                                        const TextStyle(color: Colors.white54),
                                    contentPadding:
                                        const EdgeInsets.only(top: 16),
                                    border: InputBorder.none,
                                    suffixIcon: IconButton(
                                      onPressed: _pickFile,
                                      icon: Icon(Icons.adaptive.share),
                                      color: Colors.white54,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      IconButton(
                        onPressed: _refreshWave,
                        icon: Icon(
                          isRecording ? Icons.refresh : Icons.send,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: _startOrStopRecording,
                        icon: Icon(isRecording ? Icons.stop : Icons.mic),
                        color: Colors.white,
                        iconSize: 28,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
