import 'dart:developer';

import 'package:flutter/material.dart';

class MultiPurposeButton extends StatelessWidget {
  const MultiPurposeButton({
    Key? key,
    required this.icon,
    required this.function,
    this.bgColor,
    this.iconColor,
    this.rec,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback function;
  final Color? bgColor;
  final Color? iconColor;
  final bool? rec;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: bgColor,
      ),
      child: Icon(
        icon,
        color: iconColor,
      ),
      onPressed: () {
        function();
        log("1213212312312 = $rec");
      },
    );
  }
}
