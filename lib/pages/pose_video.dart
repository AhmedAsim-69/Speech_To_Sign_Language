import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';

import 'package:stsl/services/video_player.dart';

class MlVideo extends StatefulWidget {
  const MlVideo({
    Key? key,
  }) : super(key: key);

  @override
  State<MlVideo> createState() => _MlVideoState();
}

class _MlVideoState extends State<MlVideo> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                  LocalVideoPlayer.chewieController1?.pause();
                });
              }),
          title: const Text("Pose Video"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (LocalVideoPlayer.chewieController1 == null)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "No Video Found Yet",
                          style: TextStyle(),
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    child: Chewie(
                        controller: LocalVideoPlayer.chewieController1!)),
          ],
        ));
  }
}
