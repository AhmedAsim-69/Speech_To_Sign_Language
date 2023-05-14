import 'dart:async';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

import 'package:stsl/functions/functions.dart';

class WaveBubble extends StatefulWidget {
  const WaveBubble({
    Key? key,
  }) : super(key: key);

  @override
  State<WaveBubble> createState() => WaveBubbleState();
}

class WaveBubbleState extends State<WaveBubble> {
  late StreamSubscription<PlayerState> playerStateSubscription;

  final playerWaveStyle = const PlayerWaveStyle();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await MyFunctions.preparePlayer();
      setState(() {});
    });
    MyFunctions.preparePlayer();
    playerStateSubscription =
        MyFunctions.controller.onPlayerStateChanged.listen((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    playerStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (MyFunctions.file.existsSync())
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () async {
                  setState(() {});
                  MyFunctions.controller.playerState.isPlaying
                      ? await MyFunctions.controller.pausePlayer()
                      : await MyFunctions.controller.startPlayer(
                          finishMode: FinishMode.pause,
                        );
                },
                icon: Icon(
                  (MyFunctions.controller.playerState.isPlaying ||
                          MyFunctions.controller.playerState.isStopped)
                      ? Icons.stop
                      : Icons.play_arrow,
                ),
                iconSize: 20,
              ),
              AudioFileWaveforms(
                size: Size(MediaQuery.of(context).size.width * 0.6,
                    MediaQuery.of(context).size.height * 0.035),
                playerController: MyFunctions.controller,
                waveformData: MyFunctions.controller.waveformData,
                playerWaveStyle: playerWaveStyle,
                backgroundColor: Colors.blue,
              ),
            ],
          )
        : const Text(
            "No Audio Recorded",
            textAlign: TextAlign.center,
          );
  }
}
