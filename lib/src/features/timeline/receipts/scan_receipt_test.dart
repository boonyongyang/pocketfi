// import 'dart:io';

// import 'package:flutter/material.dart';
// // import 'package:google_mlkit_entity_extraction/google_mlkit_entity_extraction.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:image_picker/image_picker.dart';

// class ScanReceipt extends StatefulWidget {
//   const ScanReceipt({Key? key}) : super(key: key);

//   @override
//   State<ScanReceipt> createState() => _ScanReceiptState();
// }

// class _ScanReceiptState extends State<ScanReceipt> {
//   bool textScanning = false;

//   XFile? imageFile;

//   String scannedText = "", scannedEntities = "", formattedText = "";

//   List<String?> regexExtraction = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("Scan a Receipt"),
//       ),
//       body: Center(
//           child: SingleChildScrollView(
//         child: Container(
//             margin: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 if (textScanning) const CircularProgressIndicator(),
//                 if (!textScanning && imageFile == null)
//                   Container(
//                     width: 300,
//                     height: 300,
//                     color: Colors.grey[300]!,
//                   ),
//                 if (imageFile != null) Image.file(File(imageFile!.path)),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 5),
//                         padding: const EdgeInsets.only(top: 10),
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             foregroundColor: Colors.grey,
//                             backgroundColor: Colors.white,
//                             shadowColor: Colors.grey[400],
//                             elevation: 10,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8.0)),
//                           ),
//                           onPressed: () {
//                             scanReceiptText(ImageSource.gallery);
//                           },
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(
//                                 vertical: 5, horizontal: 5),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 const Icon(
//                                   Icons.image,
//                                   size: 30,
//                                 ),
//                                 Text(
//                                   "Gallery",
//                                   style: TextStyle(
//                                       fontSize: 13, color: Colors.grey[600]),
//                                 )
//                               ],
//                             ),
//                           ),
//                         )),
//                     Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 5),
//                         padding: const EdgeInsets.only(top: 10),
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             foregroundColor: Colors.grey,
//                             backgroundColor: Colors.white,
//                             shadowColor: Colors.grey[400],
//                             elevation: 10,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8.0)),
//                           ),
//                           onPressed: () {
//                             scanReceiptText(ImageSource.camera);
//                           },
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(
//                                 vertical: 5, horizontal: 5),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 const Icon(
//                                   Icons.camera_alt,
//                                   size: 30,
//                                 ),
//                                 Text(
//                                   "Camera",
//                                   style: TextStyle(
//                                       fontSize: 13, color: Colors.grey[600]),
//                                 )
//                               ],
//                             ),
//                           ),
//                         )),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 // Text(formattedText),

//                 Text(
//                   scannedText,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     color: Colors.black,
//                   ),
//                 ),
//                 Text(
//                   scannedEntities,
//                   style: const TextStyle(fontSize: 20),
//                 ),
//                 Text(
//                   regexExtraction.toString(),
//                   style: const TextStyle(fontSize: 20, color: Colors.blueGrey),
//                 ),
//               ],
//             )),
//       )),
//     );
//   }

//   void scanReceiptText(ImageSource source) async {
//     try {
//       final pickedImage = await ImagePicker().pickImage(source: source);
//       if (pickedImage != null) {
//         textScanning = true;
//         imageFile = pickedImage;
//         setState(() {});
//         getRecognisedText(pickedImage);
//       }
//     } catch (e) {
//       textScanning = false;
//       imageFile = null;
//       scannedText = "Error occured while scanning";
//       setState(() {});
//     }
//   }

// // TODO this is for text recognition all in a text block
//   // void getRecognisedText(XFile image) async {
//   //   final inputImage = InputImage.fromFilePath(image.path);
//   //   // final textDetector = GoogleMlKit.vision.textDetector();
//   //   final textDetector = GoogleMlKit.vision.textRecognizer();
//   //   RecognizedText recognisedText = await textDetector.processImage(inputImage);
//   //   await textDetector.close();

//   //   scannedText = "";
//   //   for (TextBlock block in recognisedText.blocks) {
//   //     for (TextLine line in block.lines) {
//   //       scannedText = "$scannedText${line.text}\n";
//   //     }
//   //   }
//   //   textScanning = false;
//   //   setState(() {});
//   // }

//   // @override
//   // void initState() {
//   //   super.initState();
//   // }

// // TODO This is with entity extraction
//   void getRecognisedText(XFile image) async {
//     final inputImage = InputImage.fromFilePath(image.path);
//     // final textRecognizer = GoogleMlKit.vision.textRecognizer();
//     final textRecognizer = TextRecognizer();
//     final RecognizedText recognisedText =
//         await textRecognizer.processImage(inputImage);

//     // TODO -> uncomment this
//     // List<String?> regexExtraction = extractPrices(recognisedText);

//     String scannedText = "";
//     for (TextBlock block in recognisedText.blocks) {
//       for (TextLine line in block.lines) {
//         scannedText = "$scannedText${line.text}\n";
//       }
//     }

//     // TODO -> uncomment this
//     //   final entityExtractor =
//     //       EntityExtractor(language: EntityExtractorLanguage.english);
//     //   final List<EntityAnnotation> annotations =
//     //       await entityExtractor.annotateText(recognisedText.text);
//     //   String scannedEntities = '';
//     //   for (final annotation in annotations) {
//     //     scannedEntities += '${annotation.text}\n';
//     //     for (final entity in annotation.entities) {
//     //       scannedEntities += '${entity.type} : ${entity.rawValue}\n\n';
//     //     }
//     //   }
//     textRecognizer.close();
//     //   entityExtractor.close();
//     setState(() {
//       this.scannedText = scannedText;
//       // this.scannedEntities = scannedEntities;
//       // this.regexExtraction = regexExtraction;
//       textScanning = false;
//     });
//   }

//   // List<String?> extractPrices(RecognizedText recognizedText) {
//   //   final String text = recognizedText.text;
//   //   // final RegExp priceRegex = RegExp(r"(RM|MYR)\s?\d+(\.\d{2})?");
//   //   // final RegExp priceRegex =  RegExp(r"(?i)(RM|MYR)?\s?(\d+(\.\d{2})?|\.\d{2})"); // format exception
//   //   final Iterable<RegExpMatch> matches = priceRegex.allMatches(text);
//   //   final List<String?> prices = [];
//   //   for (RegExpMatch match in matches) {
//   //     prices.add(match.group(0));
//   //   }
//   //   return prices;
//   // }

//   // TODO -> uncomment this
//   // final RegExp priceRegex =
//   //     RegExp(r"(RM|MYR)?\s?(\d+(\.\d{2})?|\.\d{2})", caseSensitive: false);
//   // List<String> extractPrices(RecognizedText recognizedText) {
//   //   final List<String> matches = <String>[];
//   //   for (TextBlock block in recognizedText.blocks) {
//   //     for (TextLine line in block.lines) {
//   //       for (TextElement element in line.elements) {
//   //         String text = element.text;
//   //         final RegExpMatch? match = priceRegex.firstMatch(text);
//   //         if (match != null) {
//   //           final String? price = match.group(0);
//   //           matches.add(price!);
//   //         }
//   //       }
//   //     }
//   //   }
//   //   return matches
//   //       .where((price) =>
//   //           price.contains('MYR') ||
//   //           price.contains('RM') ||
//   //           price.startsWith('.') ||
//   //           (price.contains('.') && price.split('.').last.length == 2))
//   //       .toList();
//   // }

//   // // todo this is for text recognition with each word
//   // void getRecognisedText(XFile image) async {
//   //   final inputImage = InputImage.fromFilePath(image.path);
//   //   final textRecognizer = GoogleMlKit.vision.textRecognizer();
//   //   final RecognizedText recognisedText =
//   //       await textRecognizer.processImage(inputImage);
//   //   final entityExtractor =
//   //       GoogleMlKit.nlp.entityExtractor(EntityExtractorLanguage.english);
//   //   final List<EntityAnnotation> annotations =
//   //       await entityExtractor.annotateText(recognisedText.text);
//   //   String scannedText = '';
//   //   List<TextSpan> textSpans = [];
//   //   List<TextSpan> entitySpans = [];
//   //   for (final annotation in annotations) {
//   //     scannedText += '${annotation.text}\n';
//   //     textSpans.add(TextSpan(
//   //       text: '${annotation.text}\n',
//   //       style:
//   //           const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
//   //     ));
//   //     for (final entity in annotation.entities) {
//   //       scannedText += '${entity.type} : ${entity.rawValue}\n';
//   //       entitySpans.add(TextSpan(
//   //         text: '${entity.type}: ',
//   //         style:
//   //             const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
//   //       ));
//   //       entitySpans.add(TextSpan(
//   //         text: '${entity.rawValue}\n',
//   //         style: const TextStyle(
//   //             color: Colors.blue, fontWeight: FontWeight.normal),
//   //       ));
//   //     }
//   //   }
//   //   textRecognizer.close();
//   //   entityExtractor.close();
//   //   setState(() {
//   //     this.scannedText = scannedText;
//   //     textScanning = false;
//   //     textSpans.addAll(entitySpans);
//   //     formattedText = Column(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       children: [
//   //         TextSpan(
//   //           text: 'Scanned Text:\n',
//   //           style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
//   //         ),
//   //         ...textSpans,
//   //       ],
//   //     );
//   //   });
//   // }
// }
