import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:stsl/services/audio_player.dart';
import 'package:stsl/services/audio_recorder.dart';
import 'package:http/http.dart' as http;
import 'package:stsl/services/format_time.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //--------------------------------------------//
  // ///////////////
  File? selectedFile;
  selectSpeech() async {
    log("inside selectSpeech\n");
    final pickedFile = await FilePicker.platform.pickFiles();
    if (pickedFile != null) {
      selectedFile = File(pickedFile.files.single.path!);
    }
  }

// ///////////////
  String message = "";
  String uri = " https://5997-39-46-123-229.in.ngrok.io/upload/";

  uploadFile() async {
    final request = http.MultipartRequest(
        "POST", Uri.parse("https://5997-39-46-123-229.in.ngrok.io/upload"));
    final headers = {"Content-type": " multipart/form-data"};
    if (selectedFile != null) {
      request.files.add(http.MultipartFile('speech',
          selectedFile!.readAsBytes().asStream(), selectedFile!.lengthSync(),
          filename: selectedFile!.path.split('/').last));
    }

    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final resJson = jsonDecode(res.body);
    message = resJson['message'];
    log(message);
  }
//--------------------------------------------//

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
              onPressed: () => uploadFile(),
              child: const Text(
                "Upload Speech",
              ),
            ),
            TextButton(
              onPressed: () => selectSpeech(),
              child: const Text(
                "Select Speech",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
