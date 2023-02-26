import 'package:flutter/material.dart';

class FullWidthButtonWithText extends StatelessWidget {
  final String text;
  const FullWidthButtonWithText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 17,
        ),
      ),
    );
  }
}
