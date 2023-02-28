import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction_key.dart';

@immutable
class TransactionPayload extends MapView<String, dynamic> {
  TransactionPayload({
    // final String transactionId,
    required final String userId,
    required final double amount,
    required final String categoryName,
    required final TransactionType type,
    required final DateTime date,
    final bool isBookmark = false,
    final String? description,
    final String? thumbnailUrl, // image
    final String? fileUrl, // image
    final String? filename, // image
    final double? aspectRatio, // image
    final String? thumbnailStorageId, // image
    final String? originalFileStorageId, // image
    // final List<Tag> tags;
    // final bool shared = false;
  }) : super(
          {
            // TransactionKey.userId: userId,
            TransactionKey.amount: amount,
            TransactionKey.categoryName: categoryName,
            TransactionKey.type: type.name,
            TransactionKey.createdAt: FieldValue.serverTimestamp(),
            TransactionKey.date: date,
            TransactionKey.isBookmark: isBookmark,
            TransactionKey.description: description,
            TransactionKey.thumbnailUrl: thumbnailUrl,
            TransactionKey.fileUrl: fileUrl,
            TransactionKey.fileName: filename,
            TransactionKey.aspectRatio: aspectRatio,
            TransactionKey.thumbnailStorageId: thumbnailStorageId,
            TransactionKey.originalFileStorageId: originalFileStorageId,
          },
        );
}
