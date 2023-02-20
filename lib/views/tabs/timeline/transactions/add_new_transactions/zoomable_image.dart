import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ZoomableImage extends StatefulWidget {
  final String imagePath;

  const ZoomableImage({super.key, required this.imagePath});

  @override
  ZoomableImageState createState() => ZoomableImageState();
}

class ZoomableImageState extends State<ZoomableImage> {
  double _scale = 1.0;
  double _previousScale = 1.0;
  Offset _offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        _previousScale = _scale;
      },
      onScaleUpdate: (details) {
        setState(() {
          _scale = _previousScale * details.scale;
          _offset = details.focalPoint;
        });
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.file(
              File(widget.imagePath),
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                HapticFeedback.vibrate();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
