import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:pocketfi/src/features/receipts/domain/receipt_text_rect.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction_image.dart';

@immutable
class Receipt {
  final String transactionId;
  final double amount;
  final DateTime date;
  // final String categoryName;
  // final File file;
  final String? merchant;
  final String? note;
  final String? scannedText;
  final List<ReceiptTextRect?> extractedTextRects;
  final TransactionImage? transactionImage;

  const Receipt({
    required this.transactionId,
    required this.amount,
    required this.date,
    // required this.categoryName,
    // required this.file,
    this.note,
    this.merchant,
    required this.scannedText,
    required this.extractedTextRects,
    required this.transactionImage,
  });

  Receipt.fromJson({
    required String transactionId,
    required Map<String, dynamic> json,
  }) : this(
          transactionId: transactionId,
          amount: json['amount'],
          date: (json['date'] as Timestamp).toDate(),
          // categoryName: json['category'],
          // file: json['file'],
          merchant: json['merchant'],
          note: json['note'],
          scannedText: json['scannedText'],
          // extractedTextRects: json['extractedTextRects'] != null
          //     ? extractedTextRects.fromJson(json['extractedTextRects'])
          //     : null,
          extractedTextRects: json['extractedTextRects'] != null
              ? (json['extractedTextRects'] as List)
                  .map((e) => ReceiptTextRect.fromJson(e))
                  .toList()
              : [],
          // transactionImage: TransactionImage.fromJson(
          //   transactionId: transactionId,
          //   json: json['transactionImage'],
          // ),
          transactionImage: json[TransactionKey.transactionImage] != null
              ? TransactionImage.fromJson(
                  transactionId: transactionId,
                  json: json[TransactionKey.transactionImage],
                )
              : null,
        );

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'date': date,
        // 'category': categoryName,
        // 'file': file,
        'merchant': merchant,
        'note': note,
        'scannedText': scannedText,
        // 'receiptTextRect': extractedTextRects?.toJson(),
        'extractedTextRects': extractedTextRects
            .map((e) => e?.toJson())
            .toList()
            .cast<Map<String, dynamic>>(),
        // 'transactionImage': transactionImage.toJson(),
        if (transactionImage != null)
          TransactionKey.transactionImage: transactionImage!.toJson(),
      };

  Receipt copyWith({
    String? transactionId,
    double? amount,
    DateTime? date,
    // String? categoryName,
    File? file,
    String? merchant,
    String? note,
    String? scannedText,
    List<ReceiptTextRect?>? extractedTextRects,
    TransactionImage? transactionImage,
  }) {
    return Receipt(
      transactionId: transactionId ?? this.transactionId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      // categoryName: categoryName ?? this.categoryName,
      // file: file ?? this.file,
      merchant: merchant ?? this.merchant,
      note: note ?? this.note,
      scannedText: scannedText ?? this.scannedText,
      extractedTextRects: extractedTextRects ?? this.extractedTextRects,
      transactionImage: transactionImage ?? this.transactionImage,
    );
  }
}
