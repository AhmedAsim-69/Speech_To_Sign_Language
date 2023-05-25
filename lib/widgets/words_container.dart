import 'package:flutter/material.dart';

class WordsContainer extends StatelessWidget {
  const WordsContainer({
    Key? key,
    required this.text,
    required this.altText,
    required this.poseText,
    this.textClr,
  }) : super(key: key);

  final String text;
  final String altText;
  final String poseText;
  final Color? textClr;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.12,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF30847e),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  (text == "") ? altText : poseText,
                  style: TextStyle(color: textClr),
                ),
                (text == "")
                    ? const Text("")
                    : Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          text,
                          style: TextStyle(color: textClr),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
