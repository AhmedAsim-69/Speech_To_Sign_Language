import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';
import 'package:stsl/services/api_call.dart';

import 'package:stsl/services/pose_video_player.dart';
import 'package:stsl/widgets/words_container.dart';

class PoseVideo extends StatelessWidget {
  const PoseVideo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (PoseVideoPlayer.poseController != null) {
                  PoseVideoPlayer.poseController!.pause();
                }
                Navigator.of(context).pop();
              }),
          title: const Text("Pose Video"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (PoseVideoPlayer.poseController == null)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "No Video Found",
                          style: TextStyle(
                            color: Color(0xFFF5F5F5),
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: WordsContainer(
                            text: ApiCall.poseWordsFound,
                            altText: "No Sign Language",
                            poseText: "Pose found for: ",
                            textClr: Colors.white),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child:
                            Chewie(controller: PoseVideoPlayer.poseController!),
                      ),
                    ],
                  ),
          ],
        ));
  }
}
