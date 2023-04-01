import 'package:flutter/material.dart';
import 'package:stsl/pages/display_video.dart';

class VideoButton extends StatelessWidget {
  const VideoButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.blue[400],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        minimumSize: const Size(80, 45),
      ),
      onPressed: () {
        // setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DisplayVideo()),
        );
        // });
      },
      child: const Text('Play Video!'),
    );
  }
}
