import 'dart:io';

import 'package:flutter/material.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/timeline/receipts/receipt_highlight_image.dart';
import 'package:pocketfi/src/features/timeline/receipts/scan_receipt.dart';
import 'package:pocketfi/src/features/timeline/receipts/scanned_text_page.dart';
import 'package:pocketfi/src/features/timeline/receipts/text_highlighter_painter.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/add_new_transactions/full_screen_image_dialog.dart';
// import 'package:permission_handler/permission_handler.dart';

class ScanningTest extends StatefulWidget {
  const ScanningTest({super.key});

  @override
  State<ScanningTest> createState() => _ScanningTestState();
}

class _ScanningTestState extends State<ScanningTest> {
  String? _imagePath;

  bool textScanning = false;
  XFile? imageFile;
  String scannedText = "", scannedEntities = "", formattedText = "";
  String? selectedPrice = '';
  List<TextSpan> extractedTextSpans = [];
  List<Rect> extractedRects = [];
  List<String?> extractedPrices = [];
  List<String> extractedMerchants = [];
  List<String> extractedDates = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> getImage() async {
    // bool isCameraGranted = await Permission.camera.request().isGranted;
    // if (!isCameraGranted) {
    //   isCameraGranted =
    //       await Permission.camera.request() == PermissionStatus.granted;
    // }

    // if (!isCameraGranted) {
    //   // Have not permission to camera
    //   return;
    // }

// Generate filepath for saving
    String imagePath = join((await getApplicationSupportDirectory()).path,
        "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");

    try {
      //Make sure to await the call to detectEdge.
      bool success = await EdgeDetection.detectEdge(
        imagePath,
        canUseGallery: true,
        androidScanTitle: 'Scanning', // use custom localizations for android
        androidCropTitle: 'Crop',
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: 'Reset',
      );

      scanReceipt(XFile(imagePath));

      debugPrint('isDetected: $success');
    } catch (e) {
      debugPrint(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _imagePath = imagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Scan receipt Test'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: getImage,
                child: const Text('Scan'),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Cropped image path:'),
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
              child: Text(
                _imagePath.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            // Visibility(
            //   visible: _imagePath != null,
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Image.file(
            //       File(_imagePath ?? ''),
            //     ),
            //   ),
            // ),
            // Stack(
            //   children: [
            //     Visibility(
            //       visible: _imagePath != null,
            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Image.file(
            //           File(_imagePath ?? ''),
            //           fit: BoxFit.contain,
            //         ),
            //       ),
            //     ),
            //     Positioned(
            //       top: 30,
            //       left: 30,
            //       child: GestureDetector(
            //         child: const CircleAvatar(
            //           radius: 20,
            //           backgroundColor: AppColors.mainColor1,
            //           child: Icon(Icons.document_scanner_outlined),
            //         ),
            //         onTap: () {
            //           debugPrint(extractedRects.toString());
            //           debugPrint(extractedTextSpans.toString().toString());
            //           // toggle highlight mode
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               // builder: (context) => HighlightPage(
            //               //   extractedTextSpans: extractedTextSpans,
            //               //   extractedRects: extractedRects,
            //               //   imagePath: _imagePath,
            //               // ),
            //               builder: (context) => ReceiptHighlightImage(
            //                 imagePath: _imagePath,
            //                 extractedRects: extractedRects,
            //               ),
            //             ),
            //           );
            //         },
            //       ),
            //     ),
            //   ],
            // ),
            Visibility(
              visible: _imagePath != null,
              child: ReceiptHighlightImage(
                imagePath: _imagePath,
                extractedRects: extractedRects,
              ),
            ),
            scannedText.isNotEmpty && !textScanning
                ? ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ScannedTextPage(scannedText: scannedText),
                      ),
                    ),
                    child: const Text('View scanned text'),
                  )
                : const SizedBox(),
            const SizedBox(height: 20),
            // CustomPaint(
            //   painter: TextHighlighterPainter(
            //     textSpans: extractedTextSpans,
            //     highlightRects: extractedRects,
            //     highlightPaint: Paint()
            //       ..color = Colors.yellow
            //       ..style = PaintingStyle.stroke
            //       ..strokeWidth = 2.0,
            //   ),
            //   child: Image.file(
            //     File(_imagePath ?? ''),
            //   ),
            // ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                children: extractedTextSpans,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              selectedPrice.toString(),
              style: const TextStyle(fontSize: 20, color: Colors.blueGrey),
            ),
            const SizedBox(height: 20),
            Text(
              extractedPrices.toString(),
              style: const TextStyle(fontSize: 20, color: Colors.blueGrey),
            ),
            const SizedBox(height: 20),
            Text(
              extractedDates.toString(),
              style: const TextStyle(fontSize: 20, color: Colors.blueGrey),
            ),
            const SizedBox(height: 20),
            Text(
              extractedMerchants.toString(),
              style: const TextStyle(fontSize: 20, color: Colors.blueGrey),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void scanReceipt(XFile pickedImage) async {
    try {
      textScanning = true;
      imageFile = pickedImage;
      setState(() {});
      getRecognisedText(pickedImage);
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occured while scanning";
      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognisedText =
        await textRecognizer.processImage(inputImage);

    textRecognizer.close();
    setState(() {
      scannedText = recognisedText.text;
      extractedMerchants = extractMerchants(recognisedText);
      extractedDates = extractDates(recognisedText);
      extractedPrices = extractPrices(recognisedText);
      extractedTextSpans = getHighlightedText(recognisedText);
      extractedRects = getHighlightRects(recognisedText);
      selectedPrice = extractTotalPrice(recognisedText).toString();
      textScanning = false;
    });
  }

  List<Rect> getHighlightRects(RecognizedText recognizedText) {
    final List<Rect> highlightRects = [];
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          String text = element.text;
          final RegExpMatch? match = priceRegex.firstMatch(text);
          if (match != null) {
            final String? price = match.group(0);
            Rect rect = Rect.fromLTRB(
              element.boundingBox.left.toDouble(),
              element.boundingBox.top.toDouble(),
              element.boundingBox.right.toDouble(),
              element.boundingBox.bottom.toDouble(),
            );
            highlightRects.add(rect);
          }
        }
      }
    }
    return highlightRects;
  }

  List<TextSpan> getHighlightedText(RecognizedText recognizedText) {
    final List<TextSpan> textSpans = <TextSpan>[];
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        final List<TextSpan> lineTextSpans = <TextSpan>[];
        for (TextElement element in line.elements) {
          String text = element.text;
          final RegExpMatch? match = priceRegex.firstMatch(text);
          if (match != null) {
            final String? price = match.group(0);
            final int startIndex = match.start;
            final int endIndex = match.end;
            lineTextSpans.add(
              TextSpan(
                text: text.substring(0, startIndex),
              ),
            );
            lineTextSpans.add(
              TextSpan(
                text: text.substring(startIndex, endIndex),
                style: const TextStyle(
                  backgroundColor: Colors.yellow,
                ),
              ),
            );
            lineTextSpans.add(
              TextSpan(
                text: text.substring(endIndex),
              ),
            );
          } else {
            lineTextSpans.add(
              TextSpan(
                text: text,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            );
          }
        }
        textSpans.add(
          TextSpan(
            children: lineTextSpans,
          ),
        );
      }
    }
    return textSpans;
  }

// * prices
  final RegExp priceRegex =
      RegExp(r"(RM|MYR)?\s?(\d+(\.\d{2})?|\.\d{2})", caseSensitive: false);

  List<String> extractPrices(RecognizedText recognizedText) {
    final List<String> matches = <String>[];
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          String text = element.text;
          final RegExpMatch? match = priceRegex.firstMatch(text);
          if (match != null) {
            final String? price = match.group(0);
            matches.add(price!);
          }
        }
      }
    }

    final List<String> validPrices = matches
        .where((price) =>
            price.contains('MYR') ||
            price.contains('RM') ||
            price.startsWith('.') ||
            (price.contains('.') && price.split('.').last.length == 2))
        .toList();

    // Order the prices in descending order
    validPrices.sort((a, b) {
      double aVal = double.parse(a.replaceAll(RegExp(r"[^\d.]"), ""));
      double bVal = double.parse(b.replaceAll(RegExp(r"[^\d.]"), ""));
      return bVal.compareTo(aVal);
    });

    return validPrices;
  }

// * selected Price (from the list of extracted prices)
  final RegExp selectedPriceRegex = RegExp(
      r"(Total|Grand Total|Balance Due|Amount Due|Subtotal|Net Total|Final Total|Order Total|Invoice Total|Total Amount):\s*([+-]?\d{1,3}(?:,?\d{3})*(?:\.\d{2})?)",
      caseSensitive: false);

  double? extractTotalPrice(RecognizedText recognizedText) {
    final RegExpMatch? match = selectedPriceRegex.firstMatch(scannedText);
    if (match != null) {
      final String priceStr = match.group(1)!;
      if (double.tryParse(priceStr) != null) {
        return double.parse(priceStr);
      }
    }
    return null;
  }

// * dates
  final List<RegExp> dateRegexes = [
    RegExp(r"\d{1,2}/\d{1,2}/\d{2,4}"), // dd/mm/yyyy or d/m/yyyy
    RegExp(r"\d{1,2}\.\d{1,2}\.\d{2,4}"), // dd.mm.yyyy or d.m.yyyy
    RegExp(r"\d{1,2}-\d{1,2}-\d{2,4}"), // dd-mm-yyyy or d-m-yyyy
    RegExp(r"\d{1,2}\s+\w+\s+\d{4}"), // d Month yyyy or dd Month yyyy
    RegExp(r"\d{1,2}\w{2}\s+\w+\s+\d{4}"), // ddth Month yyyy
  ];

  List<String> extractDates(RecognizedText recognizedText) {
    final List<String> validDates = <String>[];
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          String text = element.text.trim();
          for (RegExp regex in dateRegexes) {
            final RegExpMatch? match = regex.firstMatch(text);
            if (match != null) {
              String date = match.group(0)!;
              if (!validDates.contains(date)) {
                validDates.add(date);
              }
            }
          }
        }
      }
    }
    return validDates;
  }

// * merchants
  final RegExp merchantRegex = RegExp(
    r"((Merchant|Outlet|Shop|Store):?\s*)?([A-Z][a-z]+(\s+[A-Z][a-z]+)*([\s\-]*[A-Z]?[a-z]*\d*)?)",
    caseSensitive: false,
  );

  List<String> extractMerchants(RecognizedText recognizedText) {
    final List<String> validMerchants = <String>[];
    final List<String> possibleMerchantWords = [
      'store',
      'sdn bhd',
      'sdn',
      'bhd',
      'enterprise',
      'trading',
      'co',
      'company',
      'limited',
      // 'foodpanda',
      // 'shopee',
      // 'grab',
    ];
    final List<String> invalidWords = [
      'total',
      'change',
      'amount',
      'receipt',
      'phone',
      'fax',
      'gst',
      'ssm',
      'cashier',
      'order',
      'number',
      'counter',
      'voucher',
      'thank you',
      'please come again',
      'complete',
      'approved',
      'app',
      'discount',
      'promotion',
      'sales',
      'tax',
      'service',
      'delivery',
      'delivery fee',
      'quantity',
      'item',
      'price',
      'change',
      'cash',
      'credit',
      'debit',
      'card',
      'payment',
      'mastercard',
      'visa',
      'invoice',
      'contact',
      'code',
      'scan',
    ];
    bool isHeader = true;
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        String text = line.text.trim();
        if (text.isNotEmpty && text.length > 3) {
          final RegExpMatch? match = merchantRegex.firstMatch(text);
          if (match != null) {
            final String? merchant = match.group(3);
            if (merchant != null &&
                !invalidWords.any((invalidWord) =>
                    merchant.toLowerCase().contains(invalidWord))) {
              if (isHeader) {
                validMerchants.insert(0, merchant);
              } else {
                bool hasPossibleMerchantWord = possibleMerchantWords.any(
                    (possibleWord) =>
                        text.toLowerCase().contains(possibleWord));
                if (hasPossibleMerchantWord) {
                  validMerchants.add(merchant);
                }
              }
            }
          }
        }
        isHeader = false;
      }
    }
    return validMerchants;
  }

  // Widget showReceiptPhotoFrame(File imageFile) {
  //   return InkWell(
  //     onTap: () {
  //       Navigator.of(context).push(
  //         MaterialPageRoute(
  //           builder: (context) => FullScreenImageDialog(imageFile: imageFile),
  //           fullscreenDialog: true,
  //         ),
  //       );
  //     },
  //     child: Container(
  //       width: double.infinity,
  //       height: 150.0,
  //       decoration: BoxDecoration(
  //         image: DecorationImage(
  //           image: FileImage(imageFile),
  //           fit: BoxFit.cover,
  //         ),
  //         borderRadius: BorderRadius.circular(8.0),
  //       ),
  //     ),
  //   );
  // }
}
