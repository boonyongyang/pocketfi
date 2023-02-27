import 'package:flutter/material.dart';
import 'package:pocketfi/src/constants/app_colors.dart';

class FullWidthButtonWithText extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  const FullWidthButtonWithText({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.mainColor1,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(80, 55),
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
        ),
        onPressed: onPressed,
        // {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => const CreateNewBudgetView(),
        //   ),
        // );
        // context.beamToNamed("createNewBudget"),
        // },
        child: SizedBox(
          width: double.infinity,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}
