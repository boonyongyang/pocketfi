import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  const ButtonWidget({
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
