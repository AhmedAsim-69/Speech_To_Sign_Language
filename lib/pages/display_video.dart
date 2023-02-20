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
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(
                    backgroundColor: Colors.yellow,
                    color: Colors.red,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "No Video Found Yet",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : Chewie(controller: LocalVideoPlayer.chewieController!),
    );
  }
}
