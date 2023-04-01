import 'package:flutter/material.dart';

class MultiPurposeButton extends StatelessWidget {
  const MultiPurposeButton({
    Key? key,
    required this.icon,
    required this.function,
    this.bgColor,
    this.iconColor,
    this.rec,
    this.altIcon,
    required this.updateFunc,
    this.altFunc,
    this.altFunc2,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback function;
  final VoidCallback updateFunc;
  final Color? bgColor;
  final Color? iconColor;
  final bool? rec;
  final IconData? altIcon;
  final VoidCallback? altFunc;
  final VoidCallback? altFunc2;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        minimumSize: const Size(80, 45),
      ),
      child: Icon(
        icon,
        color: iconColor,
      ),
      onPressed: () {
        function();
        if (altFunc != null && altFunc2 != null) {
          altFunc!();
          altFunc2!();
        }
        updateFunc();
      },
    );
  }
}
