import 'package:flutter/material.dart';

class WordsContainer extends StatelessWidget {
  const WordsContainer({
    Key? key,
    required this.text,
    required this.altText,
    required this.poseText,
  }) : super(key: key);

  final String text;
  final String altText;
  final String poseText;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.amber,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text((text == "")
                ? altText
                : '''$poseText: 
            $text'''),
          ),
        ),
      ),
    );
  }
}
