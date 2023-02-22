import 'dart:io';
import 'package:flutter/material.dart';

class FullScreenImageDialog extends StatelessWidget {
  final File imageFile;

  const FullScreenImageDialog({Key? key, required this.imageFile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.amber,
      insetPadding: const EdgeInsets.all(35),
      // shadowColor: Colors.green,
      backgroundColor: Colors.transparent,
      child: InkWell(
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
