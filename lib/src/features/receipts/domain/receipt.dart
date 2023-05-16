import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/src/features/receipts/domain/receipt_text_rect.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction_image.dart';

@immutable
class Receipt {
  final String transactionId;
  final double amount;
  final DateTime date;
  final String? merchant;
  final String? note;
  final String? scannedText;
  final List<ReceiptTextRect?> extractedTextRects;
  final TransactionImage? transactionImage;

  const Receipt({
    required this.transactionId,
    required this.amount,
    required this.date,
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
          merchant: json['merchant'],
          note: json['note'],
          scannedText: json['scannedText'],
          extractedTextRects: json['extractedTextRects'] != null
              ? (json['extractedTextRects'] as List)
                  .map((e) => ReceiptTextRect.fromJson(e))
                  .toList()
              : [],
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
        'merchant': merchant,
        'note': note,
        'scannedText': scannedText,
        'extractedTextRects': extractedTextRects
            .map((e) => e?.toJson())
            .toList()
            .cast<Map<String, dynamic>>(),
        if (transactionImage != null)
          TransactionKey.transactionImage: transactionImage!.toJson(),
      };

  Receipt copyWith({
    String? transactionId,
    double? amount,
    DateTime? date,
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
      merchant: merchant ?? this.merchant,
      note: note ?? this.note,
      scannedText: scannedText ?? this.scannedText,
      extractedTextRects: extractedTextRects ?? this.extractedTextRects,
      transactionImage: transactionImage ?? this.transactionImage,
    );
  }
}
