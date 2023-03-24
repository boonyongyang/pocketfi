import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pocketfi/src/constants/app_colors.dart';

class FullScreenImageDialog extends StatelessWidget {
  final File imageFile;

  const FullScreenImageDialog({Key? key, required this.imageFile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('path: ${imageFile.path}');
    return Dialog(
      // surfaceTintColor: Colors.amber,
      insetPadding: const EdgeInsets.all(35),
      shadowColor: AppColors.mainColor1,
      backgroundColor: AppColors.transparent,
      child: InkWell(
        splashColor: AppColors.transparent,
        highlightColor: AppColors.transparent,
        onTap: () => Navigator.pop(context),
        child: Column(
          children: [
            Expanded(
              child: Image.file(
                imageFile,
                fit: BoxFit.contain,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
