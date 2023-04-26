import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class WaveBubble extends StatefulWidget {
  final int? index;
  final double? width;

  const WaveBubble({
    Key? key,
    this.width,
    this.index,
  }) : super(key: key);

  @override
  State<WaveBubble> createState() => _WaveBubbleState();
}

class _WaveBubbleState extends State<WaveBubble> {
  File? file;

  final PlayerController controller = PlayerController();
  late StreamSubscription<PlayerState> playerStateSubscription;

  final playerWaveStyle = const PlayerWaveStyle(
    fixedWaveColor: Colors.white54,
    liveWaveColor: Colors.white,
    spacing: 6,
  );

  @override
  void initState() {
    super.initState();
    _preparePlayer();
    playerStateSubscription = controller.onPlayerStateChanged.listen((_) {
      setState(() {});
    });
  }

  void _preparePlayer() async {
    String dir = (await getExternalStorageDirectory())!.path;
    file = File('$dir/audio.m4a');
    if (file == null) {
      return;
    }

    controller.preparePlayer(
      path: file!.path,
      // shouldExtractWaveform: true,
    );

    controller
        .extractWaveformData(
          path: file!.path,
          // noOfSamples: playerWaveStyle.getSamplesForWidth(widget.width ?? 200),
        )
        .then((waveformData) => log(waveformData.toString()));
  }

  @override
  void dispose() {
    playerStateSubscription.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (file != null)
        ? Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.only(
                bottom: 6,
                right: 10,
                top: 6,
              ),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFF343145),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!controller.playerState.isStopped)
                    IconButton(
                      onPressed: () async {
                        controller.playerState.isPlaying
                            ? await controller.pausePlayer()
                            : await controller.startPlayer(
                                finishMode: FinishMode.loop,
                              );
                      },
                      icon: Icon(
                        controller.playerState.isPlaying
                            ? Icons.stop
                            : Icons.play_arrow,
                      ),
                      color: Colors.white,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                  AudioFileWaveforms(
                    size: Size(MediaQuery.of(context).size.width * 0.7, 20),
                    playerController: controller,
                    waveformType: WaveformType.long,
                    playerWaveStyle: playerWaveStyle,
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink(
            child: Text("NO AUDIO YET"),
          );
  }
}
