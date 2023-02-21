import 'package:flutter/material.dart';
import 'package:stsl/services/audio_player.dart';

class AudioSlider extends StatelessWidget {
  const AudioSlider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 2, 15, 2),
      child: Slider(
        min: 0,
        max: AudioPlay.duration.inMicroseconds.ceilToDouble(),
        divisions: 200,
        value: AudioPlay.position.inMicroseconds.ceilToDouble(),
        onChanged: ((value) {
          AudioPlay.audioPlayer.seek(Duration(microseconds: value.toInt()));
        }),
      ),
    );
  }
}
