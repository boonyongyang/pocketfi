import 'dart:collection';

import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/state/timeline/transaction/models/transaction_type.dart';
import 'package:pocketfi/state/timeline/transaction/models/transaction_key.dart';

@immutable
class TransactionPayload extends MapView<String, dynamic> {
  TransactionPayload(
    final String transactionId,
    final String userId,
    final double amount,
    // TODO: make to category
    final String category,
    final TransactionType type,
    final DateTime createdAt,
    final bool isBookmark,
    final String? description,
    final String? thumbnailUrl, // image
    final String? fileUrl, // image
    final String? filename, // image
    final double? aspectRatio, // image
    final String? thumbnailStorageId, // image
    final String? originalFileStorageId, // image
    // final List<Tag> tags;
    // final bool shared = false;
  ) : super(
          {
            TransactionKey.userId: userId,
            TransactionKey.amount: amount,
            TransactionKey.category: category,
            TransactionKey.type: type.name,
            TransactionKey.createdAt: createdAt,
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
