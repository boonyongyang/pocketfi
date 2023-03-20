// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:pocketfi/src/features/timeline/receipts/text_highlighter_painter.dart';

// class HighlightPage extends StatelessWidget {
//   const HighlightPage({
//     super.key,
//     required this.extractedTextSpans,
//     required this.extractedRects,
//     required this.imagePath,
//   });

//   final List<TextSpan> extractedTextSpans;
//   final List<Rect> extractedRects;
//   final String? imagePath;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("Highlighted Text"),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SizedBox(
//             height: MediaQuery.of(context).size.height * 0.8,
//             child: CustomPaint(
//               painter: TextHighlighterPainter(
//                 textSpans: extractedTextSpans,
//                 // highlightRects: extractedRects,
//                 highlightRects: const [
//                   Rect.fromLTRB(53.0, 173.0, 88.0, 163.0),
//                   Rect.fromLTRB(141.0, 173.0, 167.0, 163.0),
//                 ],
//                 highlightPaint: Paint()
//                   ..color = Colors.yellow
//                   ..style = PaintingStyle.stroke
//                   ..strokeWidth = 2.0,
//               ),
//               child: Image.file(
//                 File(imagePath ?? ''),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// * failed attempt to put rects on top of image
// import 'dart:async';
// import 'dart:io';
// import 'dart:math';

// import 'package:flutter/material.dart';

// class HighlightPage extends StatelessWidget {
//   final String? imagePath;
//   final List<Rect> extractedRects;

//   const HighlightPage({
//     Key? key,
//     required this.imagePath,
//     required this.extractedRects,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final Size screenSize = MediaQuery.of(context).size;
//     late final Size imageSize;
//     late final double scale;
//     return FutureBuilder(
//       // future: getImageSize(imagePath!),
//       future: getImageSize(AssetImage(imagePath!)),
//       builder: (context, AsyncSnapshot<Size> snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           imageSize = snapshot.data!;
//           scale = min(screenSize.width / imageSize.width,
//               screenSize.height / imageSize.height);
//           return Stack(
//             children: [
//               Image.file(
//                 File(imagePath!),
//                 fit: BoxFit.fitWidth,
//                 width: screenSize.width,
//               ),
//               ...extractedRects.map((rect) {
//                 return Positioned(
//                   left: rect.left.toDouble() * scale,
//                   top: rect.top.toDouble() * scale,
//                   width: rect.width.toDouble() * scale,
//                   height: rect.height.toDouble() * scale,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: Colors.red,
//                         width: 2.0,
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ],
//           );
//         } else {
//           return Container();
//         }
//       },
//     );
//   }

//   Future<Size> getImageSize(ImageProvider imageProvider) {
//     Completer<Size> completer = Completer<Size>();
//     ImageStreamListener listener = ImageStreamListener(
//       (ImageInfo info, _) => completer.complete(
//         Size(info.image.width.toDouble(), info.image.height.toDouble()),
//       ),
//       onError: (dynamic exception, StackTrace? stackTrace) {
//         completer.completeError(exception, stackTrace);
//       },
//     );

//     final ImageStream imageStream =
//         imageProvider.resolve(ImageConfiguration.empty);
//     imageStream.addListener(listener);

//     return completer.future;
//   }
// }

// * random rects

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pocketfi/src/constants/app_colors.dart';

class ReceiptHighlightImage extends StatefulWidget {
  final String? imagePath;
  final List<Rect> extractedRects;

  const ReceiptHighlightImage({
    super.key,
    required this.imagePath,
    required this.extractedRects,
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
                      // toggle highlight mode
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
                          // if highlight mode is true, show call _buildDetectedTextRects
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
      // ),
    );
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
          child: Container(
            width: rect.width * scale,
            height: rect.height * scale,
            decoration: BoxDecoration(
              color: AppColors.mainColor2.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
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

  // List<Widget> _buildDetectedTextRects(BuildContext context, Size imageSize,
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

  Future<Size> getImageSize(String imagePath) async {
    final File imageFile = File(imagePath);
    final Completer<Size> completer = Completer();
    final img = await decodeImageFromList(await imageFile.readAsBytes());
    completer.complete(Size(img.width.toDouble(), img.height.toDouble()));
    debugPrint('Image size: ${img.width} x ${img.height}');
    return completer.future;
  }
}


  // List<Widget> _buildRandomRects(BuildContext context, Size imageSize) {
  //   final random = Random();
  //   final List<Widget> rects = [];

  //   for (int i = 0; i < 10; i++) {
  //     // final left = random.nextDouble() * imageSize.width;
  //     // final top = random.nextDouble() * imageSize.height;
  //     final left = random.nextDouble() * MediaQuery.of(context).size.width;
  //     final top = random.nextDouble() * MediaQuery.of(context).size.height;
  //     final width = random.nextDouble() * 100 + 50;
  //     final height = random.nextDouble() * 100 + 50;

  //     // Ensure that the rectangle is fully contained within the bounds of the image
  //     final right = min(left + width, imageSize.width);
  //     final bottom = min(top + height, imageSize.height);
  //     final clippedWidth = max(right - left, 0.0);
  //     final clippedHeight = max(bottom - top, 0.0);

  //     rects.add(
  //       Positioned(
  //         left: left,
  //         top: top,
  //         child: Container(
  //           width: clippedWidth,
  //           height: clippedHeight,
  //           decoration: BoxDecoration(
  //             border: Border.all(color: Colors.yellow, width: 2),
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //         ),
  //       ),
  //     );
  //   }

  //   return rects;
  // }


        // body: Stack(
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.all(16.0),
      //       child: Image.file(
      //         image,
      //         fit: BoxFit.fitWidth,
      //         height: double.infinity,
      //         width: double.infinity,
      //       ),
      //     ),
      //     ..._buildRandomRects(context),
      //   ],
      // ),


                      // child: Stack(
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.all(padding),
                //       child: Image.file(
                //         File(imagePath!),
                //         fit: BoxFit.fitWidth,
                //         width: imageWidth,
                //         height: imageHeight,
                //       ),
                //     ),
                //     ..._buildRandomRects(context, imageSize),
                //   ],
                // ),