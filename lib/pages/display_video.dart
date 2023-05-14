import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';

import 'package:stsl/services/video_player.dart';

class DisplayVideo extends StatefulWidget {
  const DisplayVideo({
    Key? key,
  }) : super(key: key);

  @override
  State<DisplayVideo> createState() => _DisplayVideoState();
}

class _DisplayVideoState extends State<DisplayVideo> {
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
                LocalVideoPlayer.chewieController?.pause();
              });
            }),
        title: const Text("Sign Language"),
        centerTitle: true,
      ),
      body: (LocalVideoPlayer.chewieController == null)
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
          : Chewie(controller: LocalVideoPlayer.chewieController!),
    );
  }
}
