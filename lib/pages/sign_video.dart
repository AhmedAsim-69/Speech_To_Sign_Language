import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';

import 'package:stsl/services/sign_video_player.dart';

class SignVideo extends StatelessWidget {
  const SignVideo({
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
                if (SignVideoPlayer.signController != null) {
                  SignVideoPlayer.signController!.pause();
                }
                Navigator.of(context).pop();
              }),
          title: const Text("Sign Video"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (SignVideoPlayer.signController == null)
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.85,
                        child:
                            Chewie(controller: SignVideoPlayer.signController!),
                      ),
                    ],
                  ),
          ],
        ));
  }
}
