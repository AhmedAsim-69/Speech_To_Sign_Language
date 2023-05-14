import 'package:flutter/material.dart';
import 'package:stsl/pages/display_video.dart';
import 'package:stsl/pages/pose_video.dart';

class VideoButton extends StatelessWidget {
  const VideoButton({
    Key? key,
    required this.text,
    required this.isML,
  }) : super(key: key);

  final String text;
  final bool isML;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(
              width: 2,
              color: Color(0xFF30847e),
            ),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    (isML) ? const MlVideo() : const DisplayVideo()),
          );
        },
        child: Text(text),
      ),
    );
  }
}
