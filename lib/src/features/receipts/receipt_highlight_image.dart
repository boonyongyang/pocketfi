import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/receipts/add_transaction_with_receipt.dart';
import 'package:pocketfi/src/features/receipts/domain/receipt.dart';
import 'package:pocketfi/src/features/receipts/domain/receipt_text_rect.dart';
import 'package:pocketfi/src/features/receipts/scanned_text_page.dart';
import 'package:pocketfi/src/features/shared/date_picker/application/date_services.dart';
import 'package:pocketfi/src/features/shared/date_picker/presentation/transaction_date_picker.dart';
import 'package:uuid/uuid.dart';

class ReceiptHighlightImage extends StatefulHookConsumerWidget {
  final String? imagePath;
  final RecognizedText recognizedText;
  final List<ReceiptTextRect> extractedTextRects;

  const ReceiptHighlightImage({
    super.key,
    required this.imagePath,
    required this.recognizedText,
    required this.extractedTextRects,
  });

  @override
  ReceiptHighlightImageState createState() => ReceiptHighlightImageState();
}

class ReceiptHighlightImageState extends ConsumerState<ReceiptHighlightImage> {
  bool highlightMode = false;

  String? selectedPrice = '';
  DateTime? selectedDate;
  // String? selectedMerchant = '', selectedNote = '';
  late TextEditingController priceController,
      merchantController,
      noteController;

  @override
  Widget build(BuildContext context) {
    final scannedText = widget.recognizedText.text;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    priceController = useTextEditingController();
    noteController = useTextEditingController();
    merchantController = useTextEditingController();
    final isSaveButtonEnabled = useState(false);

    useEffect(
      () {
        void listener() =>
            isSaveButtonEnabled.value = priceController.text.isNotEmpty;
        priceController.addListener(listener);
        merchantController.addListener(listener);
        noteController.addListener(listener);
        return () {
          priceController.removeListener(listener);
          merchantController.removeListener(listener);
          noteController.removeListener(listener);
        };
      },
      [priceController, merchantController, noteController],
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.attach_money, color: AppColors.mainColor1),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 250.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: TextField(
                    controller: priceController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Price',
                      suffixText: '(required)',
                      suffixStyle: const TextStyle(color: Colors.red),
                      hintText: selectedPrice,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.mode, color: AppColors.mainColor1),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 250.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: TextField(
                    controller: noteController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Note',
                      suffixText: '(optional)',
                      suffixStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.store, color: AppColors.mainColor1),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 250.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: TextField(
                    controller: merchantController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Merchant',
                      suffixText: '(optional)',
                      suffixStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const TransactionDatePicker(),
          SizedBox(
            child: FutureBuilder<Size>(
              future: getImageSize(widget.imagePath!),
              builder: (BuildContext context, AsyncSnapshot<Size> snapshot) {
                if (snapshot.hasData) {
                  final imageSize = snapshot.data!;
                  const padding = 8.0;

                  final imageWidth = imageSize.width;
                  final imageHeight = imageSize.height;

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: const CircleAvatar(
                              radius: 22,
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
                          const SizedBox(width: 20.0),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ScannedTextPage(scannedText: scannedText),
                                ),
                              );
                            },
                            child: const Text('View scanned text'),
                          ),
                        ],
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
                                ..._buildDetectedTextRects(context, imageSize,
                                    imageWidth, imageHeight),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          ProceedButton(
            isSaveButtonEnabled: isSaveButtonEnabled,
            // imagePath: widget.imagePath,
            priceController: priceController,
            noteController: noteController,
            merchantController: merchantController,
            recognizedText: widget.recognizedText,
            imagePath: widget.imagePath ?? '', extractedTextRects: const [],
          ),
        ],
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

    for (ReceiptTextRect textRect in widget.extractedTextRects) {
      final rect = textRect.rect;

      rects.add(
        Positioned(
          left: rect.left * scale + padding + horizontalPadding,
          top: rect.top * scale + padding + verticalPadding,
          // child: GestureDetector(
          //   onTap: () {
          //     _showSnackBar(textRect.text);
          //   },
          child: GestureDetector(
            onTapDown: (TapDownDetails details) {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final Offset localOffset =
                  box.globalToLocal(details.globalPosition);
              debugPrint('Tapped at: ${localOffset.dx}, ${localOffset.dy}');
              _showMenu(
                textRect.text,
                context,
                details.globalPosition,
                (newValue) => setState(() => selectedPrice = newValue),
                priceController,
                merchantController,
                noteController,
              );

              _showSnackBar(textRect.text);
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

  void _showMenu(
    String text,
    BuildContext context,
    Offset position,
    Function(String?) onSelectedPriceChanged,
    TextEditingController priceController,
    TextEditingController merchantController,
    TextEditingController noteController,
  ) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final double screenHeight = overlay.size.height;
    final double availableSpaceBelow = screenHeight - position.dy;
    final double availableSpaceAbove = position.dy;
    final bool enoughSpaceBelow = availableSpaceBelow > 150;
    final bool enoughSpaceAbove = availableSpaceAbove > 150;
    final bool showAbove = !enoughSpaceBelow && enoughSpaceAbove;

    final RelativeRect positionBox = RelativeRect.fromLTRB(
      position.dx,
      showAbove ? position.dy - 50 : position.dy,
      position.dx + 1,
      showAbove ? position.dy + 1 : position.dy + 50,
    );

    if (Platform.isAndroid) {
      showMenu(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        context: context,
        position: positionBox,
        items: [
          PopupMenuItem(
            enabled: false,
            child: Text('set \'$text\' as:'),
          ),
          PopupMenuItem(
            child: const Text('Merchant'),
            onTap: () => setState(() => merchantController.text = text),
          ),
          PopupMenuItem(
            child: const Text('Date'),
            onTap: () {
              extractAndSetDate(text);
            },
          ),
          PopupMenuItem(
            child: const Text('Note'),
            onTap: () => setState(() => noteController.text = text),
          ),
          PopupMenuItem(
            child: const Text('Total'),
            onTap: () {
              setState(() => selectedPrice = text);

              // Extract numbers and at most one decimal point
              String extractedNumber = '';
              bool hasDecimal = false;
              for (int i = 0; i < selectedPrice!.length; i++) {
                if (selectedPrice![i] == '.' && !hasDecimal) {
                  extractedNumber += '.';
                  hasDecimal = true;
                } else if (RegExp(r'\d').hasMatch(selectedPrice![i])) {
                  extractedNumber += selectedPrice![i];
                }
              }

              // Assign the extracted number to the priceController
              priceController.text = extractedNumber;
            },
          ),
        ],
      );
      // FIXME ios popup menu not working
      // } else if (Platform.isIOS) {
      //   showCupertinoModalPopup(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return CupertinoContextMenu(
      //         actions: [
      //           CupertinoContextMenuAction(
      //             child: const Text('Merchant'),
      //             onPressed: () => setState(() => merchantController.text = text),
      //           ),
      //           CupertinoContextMenuAction(
      //             child: const Text('Date'),
      //             onPressed: () {},
      //           ),
      //           CupertinoContextMenuAction(
      //             child: const Text('Note'),
      //             onPressed: () => setState(() => noteController.text = text),
      //           ),
      //           CupertinoContextMenuAction(
      //             child: const Text('Total'),
      //             onPressed: () {
      //               setState(() => selectedPrice = text);

      //               // Extract numbers and at most one decimal point
      //               String extractedNumber = '';
      //               bool hasDecimal = false;
      //               for (int i = 0; i < selectedPrice!.length; i++) {
      //                 if (selectedPrice![i] == '.' && !hasDecimal) {
      //                   extractedNumber += '.';
      //                   hasDecimal = true;
      //                 } else if (RegExp(r'\d').hasMatch(selectedPrice![i])) {
      //                   extractedNumber += selectedPrice![i];
      //                 }
      //               }

      //               // Assign the extracted number to the priceController
      //               priceController.text = extractedNumber;
      //             },
      //           ),
      //         ],
      //         child: Container(
      //           color: Colors.blueGrey,
      //           width: 20.0,
      //           height: 20.0,
      //         ),
      //         // previewBuilder: (BuildContext context, Animation<double> animation,
      //         //     Widget child) {
      //         //   return Center(
      //         //     child: Text(
      //         //       'set \'$text\' as:',
      //         //       style: const TextStyle(fontSize: 16),
      //         //     ),
      //         //   );
      //         // },
      //       );
      //     },
      //   );
    }
  }

  void _showSnackBar(String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void extractAndSetDate(String text) {
    // Extract a date in format MM/dd/yyyy or dd/MM/yyyy from the string
    final RegExp dateRegExp =
        RegExp(r'(?:(\d{1,2})[\/.-](\d{1,2})[\/.-](\d{2}(?:\d{2})?))');
    final match = dateRegExp.firstMatch(text);

    if (match != null) {
      int day, month, year;

      // You can switch the month and day groups based on your date format
      day = int.parse(match.group(1)!);
      month = int.parse(match.group(2)!);
      year = int.parse(match.group(3)!);

      // If the year is two digits, adjust it to a four-digit year
      if (year < 100) {
        year += (year < 50 ? 2000 : 1900);
      }

      setState(() {
        selectedDate = DateTime(year, month, day);
      });
    }
  }

  // void _showSnackBar(Rect rect, Size imageSize) {
  //   final extractedText =
  //       extractTextFromRect(rect, imageSize, widget.recognizedText);
  //   if (extractedText != null) {
  //     final snackBar = SnackBar(content: Text(extractedText));
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   }
  // }

  // show cupertino popup with snackbar text
  // void _showSnackBar(String text) {
  //   showCupertinoModalPopup(
  //     context: context,
  //     builder: (context) => CupertinoActionSheet(
  //       title: Text(text),
  //       actions: [
  //         CupertinoActionSheetAction(
  //           child: const Text('OK'),
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

// * no 5 (moonooi workable for 100.65)
//   String? extractTextFromRect(
//       Rect rect, Size imageSize, RecognizedText recognizedText) {
//     final left = rect.left.toInt();
//     final top = rect.top.toInt();
//     final width = rect.width.toInt();
//     final height = rect.height.toInt();

//     List<String> intersectingTexts = [];

//     for (final block in recognizedText.blocks) {
//       for (final line in block.lines) {
//         for (final element in line.elements) {
//           final rectElement = element.boundingBox;
//           final x1 = max(left, rectElement.left.toInt());
//           final y1 = max(top, rectElement.top.toInt());
//           final x2 =
//               min(left + width, (rectElement.left + rectElement.width).toInt());
//           final y2 =
//               min(top + height, (rectElement.top + rectElement.height).toInt());
//           final intersection = (x2 - x1) * (y2 - y1);

//           if (intersection > 0) {
//             intersectingTexts.add(element.text);
//           }
//         }
//       }
//     }

//     if (intersectingTexts.isEmpty) {
//       return null;
//     }

//     return intersectingTexts.last;
//   }
}

// SaveButton
class ProceedButton extends ConsumerWidget {
  const ProceedButton({
    super.key,
    required this.isSaveButtonEnabled,
    required this.priceController,
    required this.merchantController,
    required this.noteController,
    required this.imagePath,
    required this.recognizedText,
    required this.extractedTextRects,
  });

  final ValueNotifier<bool> isSaveButtonEnabled;
  final TextEditingController priceController;
  final TextEditingController merchantController;
  final TextEditingController noteController;
  final String imagePath;
  final RecognizedText recognizedText;
  final List<ReceiptTextRect> extractedTextRects;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FullWidthButtonWithText(
      text: 'Proceed',
      onPressed: isSaveButtonEnabled.value
          ? () async {
              // create a receipt instance?
              final id = const Uuid().v4();
              final amount = double.parse(priceController.text);
              final date = ref.read(transactionDateProvider);
              // final image = ref.read(imageFileProvider);
              final merchant = merchantController.text;
              final note = noteController.text;

              // final receipt = Receipt(
              //   transactionId: id,
              //   amount: amount,
              //   date: date,
              //   // categoryName: chosenCategory.name,
              //   // file: imagePath,
              //   merchant: merchant,
              //   note: note,
              //   scannedText: scannedText,
              //   // if success, navigate to AddTransactionWithReceiptPage?
              //   // if fail, show snackbar?
              // );
              final receipt = Receipt(
                transactionId: id,
                amount: amount,
                date: date,
                // file: File(imagePath),
                merchant: merchant,
                note: note,
                scannedText: recognizedText.text,
                extractedTextRects: extractedTextRects,
                transactionImage: null,
              );

              // Navigate to AddTransactionWithReceipt
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) =>
                      AddTransactionWithReceipt(receipt: receipt),
                ),
              );
            }
          : null,
    );
  }
}
