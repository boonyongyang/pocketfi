import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:google_mlkit_entity_extraction/google_mlkit_entity_extraction.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/timeline/transactions/date_picker/application/selected_date_notifier.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/add_new_transactions/full_screen_image_dialog.dart';
import 'package:pocketfi/src/features/timeline/receipts/add_transaction_with_receipt.dart';
import 'package:pocketfi/src/features/timeline/receipts/application/receipt_services.dart';
import 'package:pocketfi/src/features/timeline/receipts/domain/receipt.dart';
import 'package:pocketfi/src/features/timeline/receipts/scanned_text_page.dart';
import 'package:uuid/uuid.dart';

class VerifyReceiptDetails extends StatefulHookConsumerWidget {
  const VerifyReceiptDetails({
    Key? key,
    this.pickedImage,
  }) : super(key: key);

  final XFile? pickedImage;

  @override
  VerifyReceiptDetailsState createState() => VerifyReceiptDetailsState();
}

class VerifyReceiptDetailsState extends ConsumerState<VerifyReceiptDetails> {
  bool textScanning = false;
  XFile? imageFile;
  String scannedText = "", scannedEntities = "", formattedText = "";
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
      scanTest(widget.pickedImage!);
      debugPrint('pickedImage: ${widget.pickedImage}');
    }

    if (extractedPrices.isNotEmpty) {
      // Get the highest amount from the list
      String? highestAmount = extractedPrices.reduce(
          (a, b) => double.parse(a ?? '0') > double.parse(b ?? '0') ? a : b);
      amountController.text = highestAmount ?? 's';
    }

    // if (extractedDates.isNotEmpty) {
    //   // Get the latest date from the list
    //   String? latestDate = extractedDates.first;
    //   dateController.text = latestDate;
    // }
  }

  @override
  Widget build(BuildContext context) {
    amountController =
        // useTextEditingController(text: extractedPrices.toString());
        useTextEditingController(
      text: extractedPrices.isNotEmpty ? extractedPrices[1] : '0.00',
    );
    debugPrint('extractedPrices: $extractedPrices');

    final merchantController = useTextEditingController();
    final dateController = useTextEditingController();

    // final dateController = ref.read(transactionDateProvider);
    // ref.read(transactionDateProvider.notifier).setDate(DateTime.now());

    final isProceedButtonEnabled = useState(false);
    // note, desc/notes, category, tags, location,
    // currency, amount, merchant, date, time, receipt
    // payment details?

    useEffect(
      () {
        void listener() =>
            isProceedButtonEnabled.value = amountController.text.isNotEmpty;
        // && merchantController.text.isNotEmpty &&
        // date.text.isNotEmpty;
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
              if (textScanning) const CircularProgressIndicator(),
              if (!textScanning && imageFile == null)
                Container(
                  color: Colors.grey[300]!,
                ),
              // if (imageFile != null) Image.file(File(imageFile!.path)),
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
              // const TransactionDatePicker(),
              // TextField(
              //   controller: amountController,
              //   decoration: const InputDecoration(
              //     labelText: 'Amount',
              //     hintText: 'Enter amount',
              //   ),
              // ),
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
                                signed: true, decimal: true)
                            : TextInputType.number,
                        // autofocus: true,
                        decoration: const InputDecoration(
                          // border: InputBorder.none,
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
                        // autofocus: true,
                        decoration: const InputDecoration(
                          // border: InputBorder.none,
                          prefixIcon: Icon(Icons.date_range),
                          // suffixIcon: Icon(Icons.calendar_today),
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
                        // autofocus: true,
                        decoration: const InputDecoration(
                          // border: InputBorder.none,
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
                        final receipt = Receipt(
                          id: const Uuid().v4(),
                          amount: double.parse(amountController.text),
                          date: dateController.text.isEmpty
                              ? DateTime.now()
                              : DateTime.parse(dateController.text),
                          categoryName: 'Uncategorized',
                          image: imageFile!.path,
                          merchant: merchantController.text,
                          scannedText: scannedText,
                        );
                        // TODO: need to pass in the price, merchant, date, etc
                        // TODO: set selectedTransaction or receipt to be the new transaction?
                        ref.read(receiptProvider.notifier).setReceipt(receipt);
                        debugPrint('receipt: ${receipt.toString()}');

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const AddTransactionWithReceipt(),
                          ),
                        );
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

  void scanTest(XFile pickedImage) async {
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

    List<String> dates = [];

    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        String text = line.text.trim();
        if (text.isNotEmpty) {
          // check for merchant names
          // if (text.toLowerCase().contains("merchant")) {
          //   merchantNames.add(text);
          // }
          // check for dates
          if (RegExp(r"\d{1,2}/\d{1,2}/\d{4}").hasMatch(text)) {
            dates.add(text);
          }
          // // check for prices
          // else if (RegExp(r"(RM|MYR)?\s?\d+(\.\d{2})?").hasMatch(text)) {
          //   prices.add(text);
          // }
        }
      }
    }

    textRecognizer.close();
    setState(() {
      extractedMerchants = extractMerchants(recognisedText);
      // extractedDates = dates;
      extractedDates = extractDates(recognisedText);
      scannedText = recognisedText.text;
      extractedPrices = extractPrices(recognisedText);
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

// ! ori code 1
  // void scanTest(XFile pickedImage) async {
  //   try {
  //     textScanning = true;
  //     imageFile = pickedImage;
  //     setState(() {});
  //     getRecognisedText(pickedImage);
  //   } catch (e) {
  //     textScanning = false;
  //     imageFile = null;
  //     scannedText = "Error occured while scanning";
  //     setState(() {});
  //   }
  // }

  // void getRecognisedText(XFile image) async {
  //   final inputImage = InputImage.fromFilePath(image.path);
  //   final textRecognizer = TextRecognizer();
  //   final RecognizedText recognisedText =
  //       await textRecognizer.processImage(inputImage);

  //   List<String?> regexExtraction = extractPrices(recognisedText);

  //   String scannedText = "";
  //   for (TextBlock block in recognisedText.blocks) {
  //     for (TextLine line in block.lines) {
  //       scannedText = "$scannedText${line.text}\n";
  //     }
  //   }

  //   textRecognizer.close();
  //   setState(() {
  //     this.scannedText = scannedText;
  //     this.regexExtraction = regexExtraction;
  //     textScanning = false;
  //   });
  // }

  // final RegExp priceRegex =
  //     RegExp(r"(RM|MYR)?\s?(\d+(\.\d{2})?|\.\d{2})", caseSensitive: false);

  // List<String> extractPrices(RecognizedText recognizedText) {
  //   final List<String> matches = <String>[];
  //   for (TextBlock block in recognizedText.blocks) {
  //     for (TextLine line in block.lines) {
  //       for (TextElement element in line.elements) {
  //         String text = element.text;
  //         final RegExpMatch? match = priceRegex.firstMatch(text);
  //         if (match != null) {
  //           final String? price = match.group(0);
  //           matches.add(price!);
  //         }
  //       }
  //     }
  //   }

  //   final List<String> validPrices = matches
  //       .where((price) =>
  //           price.contains('MYR') ||
  //           price.contains('RM') ||
  //           price.startsWith('.') ||
  //           (price.contains('.') && price.split('.').last.length == 2))
  //       .toList();

  //   // Order the prices in descending order
  //   validPrices.sort((a, b) {
  //     double aVal = double.parse(a.replaceAll(RegExp(r"[^\d.]"), ""));
  //     double bVal = double.parse(b.replaceAll(RegExp(r"[^\d.]"), ""));
  //     return bVal.compareTo(aVal);
  //   });

  //   return validPrices;
  // }
// ! end of ori code 1

  Widget showReceiptPhotoFrame(File imageFile) {
    // final imageFile = ref.watch(imageFileProvider);
    return (imageFile != null)
        ? InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      FullScreenImageDialog(imageFile: imageFile),
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
          )
        : const SizedBox();
  }
}

// ? not used anymore i think
// class VerifyScannedText extends StatelessWidget {
//   const VerifyScannedText({
//     super.key,
//     required TextEditingController controller,
//     required this.icon,
//   }) : _controller = controller;

//   final TextEditingController _controller;
//   final IconData icon;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(icon, color: AppColors.mainColor1),
//         ConstrainedBox(
//           constraints: const BoxConstraints(
//             maxWidth: 250,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.only(left: 16.0),
//             child: TextField(
//               // autofocus: true,
//               decoration: InputDecoration(
//                 // border: InputBorder.none,
//                 prefixIcon: Icon(icon),
//                 hintText: '',
//               ),
//               controller: _controller,
//               onSubmitted: (_) => FocusScope.of(context).nextFocus(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
