import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:pocketfi/src/constants/app_colors.dart';

class ReceiptHighlightImage extends StatefulWidget {
  final String? imagePath;
  final List<Rect> extractedRects;
  final RecognizedText recognizedText;

  const ReceiptHighlightImage({
    super.key,
    required this.imagePath,
    required this.extractedRects,
    required this.recognizedText,
  });

  @override
  State<ReceiptHighlightImage> createState() => _ReceiptHighlightImageState();
}

class _ReceiptHighlightImageState extends State<ReceiptHighlightImage> {
  bool highlightMode = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      child: FutureBuilder<Size>(
        future: getImageSize(widget.imagePath!),
        builder: (BuildContext context, AsyncSnapshot<Size> snapshot) {
          if (snapshot.hasData) {
            final imageSize = snapshot.data!;
            const padding = 8.0;

            final imageWidth = imageSize.width;
            final imageHeight = imageSize.height;

            return SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.mainColor1,
                      child: Icon(Icons.document_scanner_outlined),
                    ),
                    onTap: () {
                      setState(() {
                        highlightMode = !highlightMode;
                        debugPrint('highlight mode: $highlightMode');
                      });
                    },
                  ),
                  Center(
                    child: SizedBox(
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.8,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(padding),
                            child: Image.file(
                              File(widget.imagePath!),
                              fit: BoxFit.contain,
                              width: imageWidth,
                              height: imageHeight,
                            ),
                          ),
                          if (highlightMode)
                            ..._buildDetectedTextRects(
                                context, imageSize, imageWidth, imageHeight),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<Size> getImageSize(String imagePath) async {
    final File imageFile = File(imagePath);
    final Completer<Size> completer = Completer();
    final img = await decodeImageFromList(await imageFile.readAsBytes());
    completer.complete(Size(img.width.toDouble(), img.height.toDouble()));
    debugPrint('Image size: ${img.width} x ${img.height}');
    return completer.future;
  }

  List<Widget> _buildDetectedTextRects(BuildContext context, Size imageSize,
      double imageWidth, double imageHeight) {
    final List<Widget> rects = [];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const padding = 8.0;

    // Calculate scaling factors for width and height
    final double displayWidth = screenWidth * 0.9 - 2 * padding;
    final double displayHeight = screenHeight * 0.8 - 2 * padding;
    final double widthScale = displayWidth / imageSize.width;
    final double heightScale = displayHeight / imageSize.height;

    // Find the smaller scaling factor to maintain aspect ratio
    final double scale = min(widthScale, heightScale);

    // Calculate padding for centering the image in the SizedBox
    final double horizontalPadding =
        (displayWidth - imageSize.width * scale) / 2;
    final double verticalPadding =
        (displayHeight - imageSize.height * scale) / 2;

    for (Rect rect in widget.extractedRects) {
      rects.add(
        Positioned(
          left: rect.left * scale + padding + horizontalPadding,
          top: rect.top * scale + padding + verticalPadding,
          child: GestureDetector(
            onTap: () {
              _showSnackBar(rect, imageSize);
            },
            child: Container(
              width: rect.width * scale,
              height: rect.height * scale,
              decoration: BoxDecoration(
                color: AppColors.mainColor2.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      );
      debugPrint(
          'Rect: ${rect.left}, ${rect.top}, ${rect.width}, ${rect.height}');
    }
    debugPrint(
        'Screen size: ${MediaQuery.of(context).size.width} x ${MediaQuery.of(context).size.height}');
    return rects;
  }

  void _showSnackBar(Rect rect, Size imageSize) {
    final extractedText =
        extractTextFromRect(rect, imageSize, widget.recognizedText);
    if (extractedText != null) {
      final snackBar = SnackBar(content: Text(extractedText));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

// * no 5 (moonooi workable)
  String? extractTextFromRect(
      Rect rect, Size imageSize, RecognizedText recognizedText) {
    final left = rect.left.toInt();
    final top = rect.top.toInt();
    final width = rect.width.toInt();
    final height = rect.height.toInt();

    List<String> intersectingTexts = [];

    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        for (final element in line.elements) {
          final rectElement = element.boundingBox;
          final x1 = max(left, rectElement.left.toInt());
          final y1 = max(top, rectElement.top.toInt());
          final x2 =
              min(left + width, (rectElement.left + rectElement.width).toInt());
          final y2 =
              min(top + height, (rectElement.top + rectElement.height).toInt());
          final intersection = (x2 - x1) * (y2 - y1);

          if (intersection > 0) {
            intersectingTexts.add(element.text);
          }
        }
      }
    }

    if (intersectingTexts.isEmpty) {
      return null;
    }

    return intersectingTexts.last;
  }

// * no 4
  // String? extractTextFromRect(
  //     Rect rect, Size imageSize, RecognizedText recognizedText) {
  //   // Keep the coordinates of the rectangle as is, without scaling
  //   final left = rect.left.toInt();
  //   final top = rect.top.toInt();
  //   final width = rect.width.toInt();
  //   final height = rect.height.toInt();

  //   for (final block in recognizedText.blocks) {
  //     for (final line in block.lines) {
  //       for (final element in line.elements) {
  //         final rectElement = element.boundingBox;
  //         final x1 = max(left, rectElement.left.toInt());
  //         final y1 = max(top, rectElement.top.toInt());
  //         final x2 =
  //             min(left + width, (rectElement.left + rectElement.width).toInt());
  //         final y2 =
  //             min(top + height, (rectElement.top + rectElement.height).toInt());
  //         final intersection = (x2 - x1) * (y2 - y1);

  //         if (intersection > 0) {
  //           return element.text;
  //         }
  //       }
  //     }
  //   }

  //   return null;
  // }

// * no 3
  // String? extractTextFromRect(
  //     Rect rect, Size imageSize, RecognizedText recognizedText) {
  //   // Keep the coordinates of the rectangle as is, without scaling
  //   final left = rect.left.toInt();
  //   final top = rect.top.toInt();
  //   final width = rect.width.toInt();
  //   final height = rect.height.toInt();

  //   List<String> intersectingTexts = [];

  //   for (final block in recognizedText.blocks) {
  //     for (final line in block.lines) {
  //       for (final element in line.elements) {
  //         final rectElement = element.boundingBox;
  //         final x1 = max(left, rectElement.left.toInt());
  //         final y1 = max(top, rectElement.top.toInt());
  //         final x2 =
  //             min(left + width, (rectElement.left + rectElement.width).toInt());
  //         final y2 =
  //             min(top + height, (rectElement.top + rectElement.height).toInt());
  //         final intersection = (x2 - x1) * (y2 - y1);

  //         if (intersection > 0) {
  //           debugPrint('Intersection: $intersection');
  //           intersectingTexts.add(element.text);
  //         }
  //       }
  //     }
  //   }

  //   if (intersectingTexts.isEmpty) {
  //     return null;
  //   }

  //   return intersectingTexts.join(' ');
  // }

// * no 2
  // String? extractTextFromRect(
  //     Rect rect, Size imageSize, RecognizedText recognizedText) {
  //   final screenScale = MediaQuery.of(context).devicePixelRatio;

  //   // Scale the coordinates of the rectangle to match the screen scale
  //   final left = (rect.left * screenScale).round();
  //   final top = (rect.top * screenScale).round();
  //   final width = (rect.width * screenScale).round();
  //   final height = (rect.height * screenScale).round();

  //   List<String> intersectingTexts = [];

  //   for (final block in recognizedText.blocks) {
  //     for (final line in block.lines) {
  //       for (final element in line.elements) {
  //         final rectElement = element.boundingBox;
  //         final x1 = max(left, rectElement.left.toInt());
  //         final y1 = max(top, rectElement.top.toInt());
  //         final x2 =
  //             min(left + width, (rectElement.left + rectElement.width).toInt());
  //         final y2 =
  //             min(top + height, (rectElement.top + rectElement.height).toInt());
  //         final intersection = (x2 - x1) * (y2 - y1);

  //         if (intersection > 0) {
  //           intersectingTexts.add(element.text);
  //         }
  //       }
  //     }
  //   }

  //   if (intersectingTexts.isEmpty) {
  //     return null;
  //   }

  //   return intersectingTexts.join(' ');
  // }

// * no 1
  // String? extractTextFromRect(
  //     Rect rect, Size imageSize, RecognizedText recognizedText) {
  //   final screenScale = MediaQuery.of(context).devicePixelRatio;

  //   // Scale the coordinates of the rectangle to match the screen scale
  //   final left = (rect.left * screenScale).round();
  //   final top = (rect.top * screenScale).round();
  //   final width = (rect.width * screenScale).round();
  //   final height = (rect.height * screenScale).round();

  //   // Find the block that contains the rectangle
  //   TextBlock? block;
  //   for (final b in recognizedText.blocks) {
  //     final rect = b.boundingBox;
  //     final x1 = max(left, rect.left);
  //     final y1 = max(top, rect.top);
  //     final x2 = min(left + width, rect.left + rect.width);
  //     final y2 = min(top + height, rect.top + rect.height);
  //     final intersection = (x2 - x1) * (y2 - y1);
  //     if (intersection > 0) {
  //       block = b;
  //       break;
  //     }
  //   }

  //   if (block == null) {
  //     return null;
  //   }

  //   // Find the text line that intersects with the rectangle
  //   TextLine? line;
  //   for (final l in block.lines) {
  //     final rect = l.boundingBox;
  //     final x1 = max(left, rect.left.toInt());
  //     final y1 = max(top, rect.top.toInt());
  //     final x2 = min(left + width, (rect.left + rect.width).toInt());
  //     final y2 = min(top + height, (rect.top + rect.height).toInt());
  //     final intersection = (x2 - x1) * (y2 - y1);
  //     if (intersection > 0) {
  //       line = l;
  //       break;
  //     }
  //   }

  //   if (line == null) {
  //     return null;
  //   }

  //   // Extract the text from the line
  //   final text = line.text;
  //   return text;
  // }

  List<Widget> _buildRandomRects(BuildContext context, Size imageSize) {
    final random = Random();
    final List<Widget> rects = [];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    for (int i = 0; i < 3; i++) {
      final left = random.nextDouble() * screenWidth;
      final top = random.nextDouble() * screenHeight;
      // final left = random.nextDouble() * imageSize.width;
      // final top = random.nextDouble() * imageSize.height;
      final width = random.nextDouble() * 100 + 50;
      final height = random.nextDouble() * 100 + 50;

      // Calculate scaling factors for width and height
      final widthScale = MediaQuery.of(context).size.width / screenWidth;
      final heightScale = MediaQuery.of(context).size.height / screenHeight;
      // final widthScale = MediaQuery.of(context).size.width / imageSize.width;
      // final heightScale = MediaQuery.of(context).size.height / imageSize.height;

      rects.add(
        Positioned(
          left: left * widthScale,
          top: top * heightScale,
          child: Container(
            width: width * widthScale,
            height: height * heightScale,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.yellow, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
      // print the rect coordinates
      debugPrint('Rect $i: $left, $top, $width, $height');
    }
    debugPrint(
        'Screen size: ${MediaQuery.of(context).size.width} x ${MediaQuery.of(context).size.height}');
    return rects;
  }
}
