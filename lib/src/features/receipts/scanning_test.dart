import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pocketfi/src/features/receipts/receipt_highlight_image.dart';
import 'package:pocketfi/src/features/receipts/scanned_text_page.dart';
import 'package:pocketfi/src/features/receipts/domain/receipt_text_rect.dart';

class ScanningTest extends StatefulHookConsumerWidget {
  const ScanningTest({super.key});

  @override
  ScanningTestState createState() => ScanningTestState();
}

class ScanningTestState extends ConsumerState<ScanningTest> {
  String? _imagePath;

  bool textScanning = false;
  XFile? imageFile;
  RecognizedText recognizedText = RecognizedText(
    text: '',
    blocks: [],
  );
  String scannedText = "", scannedEntities = "", formattedText = "";
  String? selectedPrice = '';
  List<TextSpan> extractedTextSpans = [];
  List<Rect> extractedRects = [];
  List<String?> extractedPrices = [];
  List<String> extractedMerchants = [];
  List<String> extractedDates = [];
  List<ReceiptTextRect> extractedTextRects = [];

  @override
  void initState() {
    super.initState();
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
            Visibility(
              visible: _imagePath != null,
              child: ReceiptHighlightImage(
                recognizedText: recognizedText,
                imagePath: _imagePath,
                extractedTextRects: extractedTextRects,
              ),
            ),
            scannedText.isNotEmpty && !textScanning
                ? ElevatedButton(
                    onPressed: () {
                      debugPrint(
                          'scannedText: $scannedText, extractedTextSpans: $extractedTextSpans');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ScannedTextPage(scannedText: scannedText),
                        ),
                      );
                    },
                    child: const Text('View scanned text'),
                  )
                : const SizedBox(),
            const SizedBox(height: 20),
            IconButton(
              onPressed: () {
                debugPrint('printing extracted rects and text spans');
                debugPrint(extractedRects.toString());
                debugPrint(extractedTextSpans.toString());
              },
              icon: const Icon(
                Icons.square_foot,
                size: 50.0,
              ),
            ),
            const SizedBox(height: 20),
            RichText(text: TextSpan(children: extractedTextSpans)),
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

  Future<void> getImage() async {
    String imagePath = join((await getApplicationSupportDirectory()).path,
        "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");
    try {
      bool success = await EdgeDetection.detectEdge(
        imagePath,
        canUseGallery: true,
        androidScanTitle: 'Scanning',
        androidCropTitle: 'Crop',
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: 'Reset',
      );

      if (success) {
        File imageFile = File(imagePath);
        Uint8List imageBytes = await imageFile.readAsBytes();
        Uint8List compressedBytes = Uint8List.fromList(
          await FlutterImageCompress.compressWithList(
            imageBytes,
            minWidth: 480,
            minHeight: 640,
            quality: 85,
            format: CompressFormat.jpeg,
          ),
        );
        await imageFile.writeAsBytes(compressedBytes);
        scanReceipt(XFile(imagePath));
        if (!mounted) return;
        setState(() {
          _imagePath = imagePath;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  List<ReceiptTextRect> createTextRects(RecognizedText recognizedText) {
    List<ReceiptTextRect> extractedTextRects = [];

    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        for (final element in line.elements) {
          final rect = element.boundingBox;
          final text = element.text;
          extractedTextRects.add(ReceiptTextRect(rect: rect, text: text));
        }
      }
    }
    return extractedTextRects;
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
    recognizedText = await textRecognizer.processImage(inputImage);

    textRecognizer.close();
    setState(() {
      recognizedText = recognizedText;
      scannedText = recognizedText.text;
      extractedMerchants = extractMerchants(recognizedText);
      extractedDates = extractDates(recognizedText);
      extractedPrices = extractPrices(recognizedText);
      extractedTextSpans = getHighlightedTextSpans(recognizedText);
      extractedRects = getHighlightRects(recognizedText);
      extractedTextRects = createTextRects(recognizedText);
      selectedPrice = extractTotalPrice(recognizedText).toString();
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

  List<TextSpan> getHighlightedTextSpans(RecognizedText recognizedText) {
    final List<TextSpan> textSpans = <TextSpan>[];
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        final List<TextSpan> lineTextSpans = <TextSpan>[];
        for (TextElement element in line.elements) {
          String text = element.text;
          final RegExpMatch? match = priceRegex.firstMatch(text);
          if (match != null) {
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
}
