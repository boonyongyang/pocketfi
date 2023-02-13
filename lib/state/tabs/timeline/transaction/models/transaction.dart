import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/state/tabs/timeline/transaction/models/transaction_type.dart';
// import 'package:pocketfi/state/timeline/transaction/models/tag.dart';
// import 'package:pocketfi/state/timeline/transaction/models/tag_key.dart';
import 'package:pocketfi/state/tabs/timeline/transaction/models/transaction_key.dart';

@immutable
class Transaction {
  final String transactionId;
  final String userId;
  final double amount;
  // TODO: make to category
  final String category;
  final TransactionType type;
  final DateTime createdAt;
  final bool isBookmark = false;
  final String? description;
  final String? thumbnailUrl; // image
  final String? fileUrl; // image
  final String? filename; // image
  final double? aspectRatio; // image
  final String? thumbnailStorageId; // image
  final String? originalFileStorageId; // image
  // final List<Tag> tags;
  // final bool shared = false;

  Transaction({
    required this.transactionId,
    required this.amount,
    required this.category,
    required Map<String, dynamic> json,
  })  : userId = json[TransactionKey.userId],
        description = json[TransactionKey.description],
        type = TransactionType.values.firstWhere(
          (transactionType) =>
              transactionType.name == json[TransactionKey.type],
          orElse: () => TransactionType.expense,
        ),
        createdAt = (json[TransactionKey.createdAt] as Timestamp).toDate(),
        thumbnailUrl = json[TransactionKey.thumbnailUrl],
        fileUrl = json[TransactionKey.fileUrl],
        filename = json[TransactionKey.fileName],
        aspectRatio = json[TransactionKey.aspectRatio],
        thumbnailStorageId = json[TransactionKey.thumbnailStorageId],
        // isBookmark = json[TransactionKey.isBookmark],
        originalFileStorageId = json[TransactionKey.originalFileStorageId];
  // tags = [
  //   for (final tag in json[TransactionKey.tags])
  //     Tag(
  //       tagId: tag[TagKey.tagId],
  //       tagName: tag[TagKey.tagName],
  //       tagColor: tag[TagKey.tagColor],
  //       tagIcon: tag[TagKey.tagIcon],
  //     ),
  // ],
  // shared = json[TransactionKey.shared];
}
