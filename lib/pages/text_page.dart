import 'package:flutter/material.dart';

import 'package:stsl/pages/display_video.dart';

import 'package:stsl/services/upload_file.dart';

bool isRec = false;
bool isPlay = false;

class TextPage extends StatefulWidget {
  const TextPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                // keyboardType: TextInputType.none,
                // textAlign: TextAlign.center,
                // controller: weightctrl,
                decoration: InputDecoration(
                  labelText: 'Enter Text Input: ',
                  // floatingLabelAlignment: FloatingLabelAlignment.center,
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
                    borderSide: const BorderSide(width: 2, color: Colors.green),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorStyle:
                      const TextStyle(color: Colors.redAccent, fontSize: 14),
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(left: 10, top: 13),
                    child: Text(
                      'Kg',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  } else if (int.parse(value) < 20 || int.parse(value) > 350) {
                    return 'Please enter weight between 20-350 Kgs';
                  }
                  return null;
                },
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
