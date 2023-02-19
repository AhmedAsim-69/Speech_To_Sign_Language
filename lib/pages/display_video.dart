import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Video Player!!"),
        centerTitle: true,
      ),
      body: (LocalVideoPlayer.chewieController == null)
          ? Column(
              children: const [
                Text("No Video Found Yet"),
                CircularProgressIndicator(),
              ],
            )
          : Chewie(controller: LocalVideoPlayer.chewieController!),
    );
  }
}
