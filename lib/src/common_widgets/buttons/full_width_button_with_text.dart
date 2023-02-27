import 'package:flutter/material.dart';
import 'package:pocketfi/src/constants/app_colors.dart';

class FullWidthButtonWithText extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double padding;
  final double height;

  const FullWidthButtonWithText({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.mainColor1,
    this.textColor = Colors.white,
    this.padding = 16.0,
    this.height = 55.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: Size(80, height),
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
          ),
          onPressed: onPressed,
          child: SizedBox(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
