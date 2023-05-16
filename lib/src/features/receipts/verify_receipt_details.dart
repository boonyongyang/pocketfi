import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/shared/image_upload/presentation/full_screen_image_dialog.dart';
import 'package:pocketfi/src/features/receipts/scanned_text_page.dart';

class VerifyReceiptDetails extends StatefulHookConsumerWidget {
  const VerifyReceiptDetails({
    Key? key,
    required this.pickedImage,
  }) : super(key: key);

  final XFile? pickedImage;

  @override
  VerifyReceiptDetailsState createState() => VerifyReceiptDetailsState();
}

class VerifyReceiptDetailsState extends ConsumerState<VerifyReceiptDetails> {
  bool textScanning = false;
  XFile? imageFile;
  String scannedText = "", scannedEntities = "", formattedText = "";
  String? selectedPrice = '';
  List<String?> extractedPrices = [];
  List<String> extractedMerchants = [];
  List<String> extractedDates = [];
  late TextEditingController amountController;
  late TextEditingController merchantController;
  late TextEditingController dateController;

  @override
  void initState() {
    super.initState();
    if (widget.pickedImage != null) {
      scanReceipt(widget.pickedImage!);
      debugPrint('pickedImage: ${widget.pickedImage?.name}');
    }
  }

  @override
  Widget build(BuildContext context) {
    amountController = useTextEditingController(
      text: extractedPrices.isNotEmpty ? extractedPrices[0] : '0.20',
    );
    debugPrint('extractedPrices: $extractedPrices');

    final merchantController = useTextEditingController(
        text: extractedMerchants.isNotEmpty
            ? extractedMerchants[0]
            : 'Foodpanda');

    final dateController = useTextEditingController();

    final isProceedButtonEnabled = useState(false);
    // note, desc/notes, category, tags, location,
    // currency, amount, merchant, date, time, receipt
    // payment details?

    useEffect(
      () {
        void listener() =>
            isProceedButtonEnabled.value = amountController.text.isNotEmpty;
        amountController.addListener(listener);
        return () => amountController.removeListener(listener);
      },
      [amountController],
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Confirm Receipt Details"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (textScanning)
                const Padding(
                  padding: EdgeInsets.only(top: 100.0),
                  child: CircularProgressIndicator(),
                ),
              if (!textScanning && imageFile == null)
                Container(
                  color: Colors.grey[300],
                ),
              if (imageFile != null)
                showReceiptPhotoFrame(File(imageFile!.path)),
              const SizedBox(height: 20),
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
              Row(
                children: [
                  const Icon(Icons.attach_money, color: AppColors.mainColor1),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 250,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: TextField(
                        keyboardType: Platform.isIOS
                            ? const TextInputType.numberWithOptions(
                                decimal: true,
                              )
                            : TextInputType.number,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.attach_money),
                          hintText: '0.00',
                        ),
                        controller: amountController,
                        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.date_range, color: AppColors.mainColor1),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 250,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.date_range),
                          hintText: '10/03/2023',
                        ),
                        controller: dateController,
                        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.store, color: AppColors.mainColor1),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 250,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.store),
                          hintText: 'merchant (optional)',
                        ),
                        controller: merchantController,
                        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      ),
                    ),
                  ),
                ],
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
              ElevatedButton(
                onPressed: isProceedButtonEnabled.value
                    ? () {
                        // final receipt = Receipt(
                        //   transactionId: const Uuid().v4(),
                        //   amount: double.parse(amountController.text),
                        //   date: dateController.text.isEmpty
                        //       ? DateTime.now()
                        //       : DateTime.parse(dateController.text),
                        //   // categoryName: 'Uncategorized',
                        //   // categoryName: 'Food and Drinks',
                        //   file: imageFile!.path,
                        //   merchant: merchantController.text,
                        //   scannedText: scannedText,
                        // );
                        // // TODO: need to pass in the price, merchant, date, etc
                        // // TODO: set selectedTransaction or receipt to be the new transaction?
                        // ref.read(receiptProvider.notifier).setReceipt(receipt);
                        // debugPrint('receipt: ${receipt.toString()}');

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         AddTransactionWithReceipt(receipt: receipt),
                        //   ),
                        // );
                      }
                    : null,
                child: const Text('Proceed'),
              ),
            ],
          ),
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
      selectedPrice = extractTotalPrice(recognisedText).toString();
      textScanning = false;
    });
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

  Widget showReceiptPhotoFrame(File imageFile) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FullScreenImageDialog(imageFile: imageFile),
            fullscreenDialog: true,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 150.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(imageFile),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
    // // final imageFile = ref.watch(imageFileProvider);
    // return (imageFile != null)
    //     ? InkWell(
    //         onTap: () {
    //           Navigator.of(context).push(
    //             MaterialPageRoute(
    //               builder: (context) =>
    //                   FullScreenImageDialog(imageFile: imageFile),
    //               fullscreenDialog: true,
    //             ),
    //           );
    //         },
    //         child: Container(
    //           width: double.infinity,
    //           height: 150.0,
    //           decoration: BoxDecoration(
    //             image: DecorationImage(
    //               image: FileImage(imageFile),
    //               fit: BoxFit.cover,
    //             ),
    //             borderRadius: BorderRadius.circular(8.0),
    //           ),
    //         ),
    //       )
    //     : const SizedBox();
  }
}
