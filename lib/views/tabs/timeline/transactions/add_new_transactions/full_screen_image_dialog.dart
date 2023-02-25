import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pocketfi/views/constants/app_colors.dart';

class FullScreenImageDialog extends StatelessWidget {
  final File imageFile;

  const FullScreenImageDialog({Key? key, required this.imageFile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // surfaceTintColor: Colors.amber,
      insetPadding: const EdgeInsets.all(35),
      shadowColor: AppSwatches.mainColor1,
      backgroundColor: AppSwatches.transparent,
      child: InkWell(
        splashColor: AppSwatches.transparent,
        highlightColor: AppSwatches.transparent,
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
