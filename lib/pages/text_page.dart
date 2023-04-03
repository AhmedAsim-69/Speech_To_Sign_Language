import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:stsl/functions/functions.dart';

import 'package:stsl/services/api_call.dart';
import 'package:stsl/services/user_simple_preferences.dart';
import 'package:stsl/widgets/video_button.dart';
import 'package:stsl/services/video_player.dart';
import 'package:stsl/widgets/words_container.dart';

class TextPage extends StatefulWidget {
  const TextPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  @override
  void initState() {
    super.initState();

    MyFunctions.initStorage();
    LocalVideoPlayer.videoController();
    ApiCall.wordsFound = UserSimplePreferences.getWords() ?? "";
    ApiCall.wordsNotFound = UserSimplePreferences.getNotWords() ?? "";
  }

  @override
  void dispose() {
    if (LocalVideoPlayer.chewieController != null) {
      LocalVideoPlayer.chewieController!.dispose();
    }
    super.dispose();
  }

  void _updateState() {
    setState(() {});
  }

  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
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
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    labelText: 'Enter Text Input: ',
                    alignLabelWithHint: true,
                    labelStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 2,
                        color: Color.fromARGB(255, 79, 168, 197),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 2,
                        color: Color.fromARGB(255, 79, 168, 197),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.green),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorStyle:
                        const TextStyle(color: Colors.redAccent, fontSize: 14),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Text';
                    }
                    return null;
                  },
                ),
              ),
              TextButton(
                onPressed: () async {
                  await ApiCall.uploadText(
                      _textEditingController.text, _updateState, context);
                },
                child: const Text(
                  "Upload Text",
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
