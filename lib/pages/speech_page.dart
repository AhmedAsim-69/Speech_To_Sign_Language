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
import 'package:stsl/services/wave_bubble.dart';
import 'package:stsl/services/user_simple_preferences.dart';
import 'package:stsl/services/video_player.dart';

import 'package:stsl/utils/theme_data.dart';
import 'package:stsl/widgets/snackbar.dart';

import 'package:stsl/widgets/video_button.dart';
import 'package:stsl/widgets/words_container.dart';

class SpeechPage extends StatefulWidget {
  const SpeechPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SpeechPage> createState() => _SpeechPageState();
}

bool isRec = false;
bool isPlay = false;

class _SpeechPageState extends State<SpeechPage> {
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
    ApiCall.wordsNotFound = UserSimplePreferences.getNotWords() ?? "";
    LocalVideoPlayer.videoController();
    _initialiseControllers();
  }

  @override
  void dispose() {
    AudioRecorder.recorder.closeRecorder();
    if (LocalVideoPlayer.chewieController != null) {
      LocalVideoPlayer.chewieController!.dispose();
    }
    if (LocalVideoPlayer.chewieController1 != null) {
      LocalVideoPlayer.chewieController1!.dispose();
    }
    if (LocalVideoPlayer.chewieController2 != null) {
      LocalVideoPlayer.chewieController2!.dispose();
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Speech Page"),
        ),
        drawer: Drawer(
            backgroundColor: Colors.black,
            child: ListView(
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Color(0xFF42a79d),
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('Pakistan Sign Express')),
                  ),
                ),
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
                  height: MediaQuery.of(context).size.height * 0.1,
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
            )),
        body: ModalProgressHUD(
          opacity: 0.8,
          blur: 1.0,
          progressIndicator: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              Text(
                "This may take a while...",
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
                      altText: "No Video Yet",
                      poseText: "Pose Found for the following words: "),
                ),
                SizedBox(
                  height: sizedBoxHeight,
                ),
                WordsContainer(
                    text: ApiCall.wordsNotFound,
                    altText: "No Sentence Yet",
                    poseText: "Pose Not Found for the following words: "),
                SizedBox(
                  height: sizedBoxHeight,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    VideoButton(text: "Play Human Video", isML: false),
                    VideoButton(text: "Play Pose Video", isML: true),
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
                          final path =
                              (await getExternalStorageDirectory())!.path;
                          if (mounted) {
                            (File('$path/audio.wav').existsSync())
                                ? await ApiCall.uploadSpeech(
                                    _updateState, context)
                                : ShowSnackbar.showsnackbar(
                                    Colors.black54,
                                    Colors.yellow,
                                    Icons.warning,
                                    "No Audio Recorded",
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
                                            await ApiCall.uploadText(
                                                _textEditingController.text,
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
                        onPressed: () {},
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
