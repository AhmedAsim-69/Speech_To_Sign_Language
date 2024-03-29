import 'package:flutter/material.dart';

import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:stsl/functions/functions.dart';

import 'package:stsl/services/api_call.dart';
import 'package:stsl/services/audio_recorder.dart';
import 'package:stsl/services/pose_video_player.dart';
import 'package:stsl/services/sign_video_player.dart';
import 'package:stsl/services/user_simple_preferences.dart';
import 'package:stsl/services/wave_bubble.dart';

import 'package:stsl/utils/theme_data.dart';
import 'package:stsl/widgets/snackbar.dart';

import 'package:stsl/widgets/video_button.dart';
import 'package:stsl/widgets/words_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

bool isRec = false;
bool isPlay = false;

class _HomePageState extends State<HomePage> {
  final RecorderController recorderController = RecorderController();

  bool _isDarkMode = false;
  bool _isFormValid = true;
  final _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    UserSimplePreferences.readData('themeMode').then((value) {
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _isDarkMode = false;
      } else {
        _isDarkMode = true;
      }
    });
    AudioRecorder.initRecorder();
    MyFunctions.initStorage();
    ApiCall.wordsFound = UserSimplePreferences.getWords() ?? "";
    ApiCall.poseWordsFound = UserSimplePreferences.getPoseWords() ?? "";
    ApiCall.wordsNotFound = UserSimplePreferences.getNotWords() ?? "";

    SignVideoPlayer.videoController();
    PoseVideoPlayer.videoController();
    _initialiseControllers();
  }

  @override
  void dispose() {
    AudioRecorder.recorder.closeRecorder();
    if (SignVideoPlayer.signController != null) {
      SignVideoPlayer.signController!.dispose();
    }
    if (PoseVideoPlayer.poseController != null) {
      PoseVideoPlayer.poseController!.dispose();
    }

    super.dispose();
  }

  void _initialiseControllers() {
    recorderController
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }

  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final sizedBoxHeight = MediaQuery.of(context).size.height * 0.106;

    return Consumer<ThemeNotifier>(builder: (context, theme, _) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Pakistan Sign Express"),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Material(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/logos/app_logo.png",
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        'Pakistan Sign Express',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
              const Divider(),
              SwitchListTile(
                  title: const Text("Dark Mode"),
                  value: _isDarkMode,
                  onChanged: (value) {
                    _isDarkMode = value;
                    if (_isDarkMode) {
                      theme.setDarkMode();
                    } else {
                      theme.setLightMode();
                    }
                  }),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.09,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 80,
                    width: 80,
                    child: Image.asset(
                      'assets/logos/uet_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Text(
                  "University of Engineering and Technology, Lahore",
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(),
              const Text(
                "2019-FYP-13",
                textAlign: TextAlign.center,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
                child: Text(
                  "Real-time Speech-to-Pakistan Sign Language using Neural Networks",
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(),
              const Text(
                "Supervised By:",
                textAlign: TextAlign.center,
              ),
              const Text(
                "Prof. Dr. Kashif Javed",
                textAlign: TextAlign.center,
              ),
              const Divider(),
              const Text(
                "2019-EE-31: Ahmed Asim",
                textAlign: TextAlign.center,
              ),
              const Text(
                "2019-EE-27: Muhammad Ashar Khan",
                textAlign: TextAlign.center,
              ),
              const Text(
                "2019-EE-51: Aimon Humayun",
                textAlign: TextAlign.center,
              ),
              const Divider(),
              const Text(
                "App Developer: Ahmed Asim",
                textAlign: TextAlign.center,
              ),
              const Text(
                "Email: ahmedk082@gmail.com ",
                textAlign: TextAlign.center,
              ),
              const Divider(),
            ],
          ),
        ),
        body: ModalProgressHUD(
          opacity: 0.8,
          blur: 1.0,
          progressIndicator: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(
                height: 20,
              ),
              Text(
                "This may take a few minutes...",
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
          inAsyncCall: ApiCall.isLoading,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: WordsContainer(
                    text: ApiCall.wordsFound,
                    altText: "No Sign Language",
                    poseText: "Sign Language found for the following words: ",
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeight,
                ),
                WordsContainer(
                  text: ApiCall.wordsNotFound,
                  altText: "No Sign Language",
                  poseText: "Sign Language Not Found for the following words: ",
                ),
                SizedBox(
                  height: sizedBoxHeight,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    VideoButton(
                      text: "Play Human Video",
                      isML: false,
                    ),
                    VideoButton(
                      text: "Play Pose Video",
                      isML: true,
                    ),
                  ],
                ),
                SizedBox(
                  height: sizedBoxHeight,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.93,
                  height: 50,
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                  margin:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF42a79d),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(child: WaveBubble()),
                      const VerticalDivider(
                        thickness: 1,
                        width: 2,
                      ),
                      IconButton(
                        onPressed: () async {
                          if (!isRec) {
                            final path =
                                (await getExternalStorageDirectory())!.path;
                            if (mounted) {
                              File audio = File('$path/audio.wav');
                              (audio.existsSync())
                                  ? await ApiCall.uploadSpeech(audio, null,
                                      true, false, false, _updateState, context)
                                  : ShowSnackbar.showsnackbar(
                                      Colors.black54,
                                      Colors.yellow,
                                      Icons.warning,
                                      "No Audio Recorded",
                                      context);
                            }
                          } else {
                            ShowSnackbar.showsnackbar(
                                Colors.black54,
                                Colors.yellow,
                                Icons.warning,
                                "Audio is being recorded",
                                context);
                          }
                        },
                        icon: const Icon(
                          Icons.upload,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeight,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: isRec
                            ? StreamBuilder<RecordingDisposition>(
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
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                height: _isFormValid
                                    ? MediaQuery.of(context).size.height * 0.06
                                    : MediaQuery.of(context).size.height * 0.1,
                                decoration: BoxDecoration(
                                  color:
                                      _isFormValid ? Colors.red : Colors.black,
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    controller: _textEditingController,
                                    enableInteractiveSelection: false,
                                    textAlign: TextAlign.left,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          15, 0, 0, 0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      hintText: "Type Something...",
                                      hintStyle: const TextStyle(),
                                      suffixIcon: IconButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _isFormValid = true;
                                            await ApiCall.uploadSpeech(
                                                null,
                                                _textEditingController.text,
                                                false,
                                                true,
                                                false,
                                                _updateState,
                                                context);
                                          } else {
                                            _isFormValid = false;
                                          }
                                          setState(() {});
                                        },
                                        icon: const Icon(
                                          Icons.send,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a word or sentence';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                      ),
                      FloatingActionButton.small(
                        heroTag: " recorder",
                        onPressed: (() {
                          isRec
                              ? MyFunctions.stopRec()
                              : MyFunctions.startRec();
                          _updateState();
                          Future.delayed(
                            const Duration(seconds: 2),
                            (() {
                              _updateState();
                            }),
                          );
                        }),
                        child: Icon(
                          isRec ? Icons.stop : Icons.mic,
                          size: 25,
                        ),
                      ),
                      FloatingActionButton.small(
                        heroTag: "pose video",
                        onPressed: () async {
                          if (!isRec) {
                            if (_textEditingController.text.isNotEmpty) {
                              _isFormValid = true;
                              await ApiCall.uploadSpeech(
                                  null,
                                  _textEditingController.text,
                                  false,
                                  true,
                                  true,
                                  _updateState,
                                  context);
                            } else {
                              final path =
                                  (await getExternalStorageDirectory())!.path;
                              if (mounted) {
                                File audio = File('$path/audio.wav');
                                (audio.existsSync())
                                    ? await ApiCall.uploadSpeech(
                                        audio,
                                        null,
                                        true,
                                        false,
                                        true,
                                        _updateState,
                                        context)
                                    : ShowSnackbar.showsnackbar(
                                        Colors.black54,
                                        Colors.yellow,
                                        Icons.warning,
                                        "No Audio Recorded",
                                        context);
                              }
                            }
                          } else {
                            ShowSnackbar.showsnackbar(
                                Colors.black54,
                                Colors.yellow,
                                Icons.warning,
                                "Audio is being recorded",
                                context);
                          }
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.front_hand_sharp,
                          size: 25,
                        ),
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
