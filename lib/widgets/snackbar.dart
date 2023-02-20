import 'package:flutter/material.dart';

showsnackbar(Color color, String text, BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
      content: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        height: 56,
        child: Row(
          children: [
            const Icon(
              Icons.warning_rounded,
              color: Color(0xffffffff),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            const Icon(
              Icons.close,
              color: Color(0xffffffff),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
    ),
  );
}
