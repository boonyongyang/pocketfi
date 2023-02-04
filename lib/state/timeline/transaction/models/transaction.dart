import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/state/category/models/category.dart';
import 'package:pocketfi/state/timeline/transaction/create_new_transaction/transaction_type.dart';
// import 'package:pocketfi/state/timeline/transaction/models/tag.dart';
// import 'package:pocketfi/state/timeline/transaction/models/tag_key.dart';
import 'package:pocketfi/state/timeline/transaction/models/transaction_key.dart';

@immutable
class Transaction {
  final String transactionId;
  final String userId;
  final double amount;
  final Category category;
  final String description;
  final DateTime createdAt;
  final String thumbnailUrl;
  final String fileUrl;
  final String filename;
  final double aspectRatio;
  final String thumbnailStorageId;
  final String originalFileStorageId;
  final TransactionType type;
  // final List<Tag> tags;
  // final bool shared = false;
  // final bool isBookmark = false;

  Transaction({
    required this.transactionId,
    required this.amount,
    required this.category,
    required Map<String, dynamic> json,
  })  : userId = json[TransactionKey.userId],
        description = json[TransactionKey.description],
        createdAt = (json[TransactionKey.createdAt] as Timestamp).toDate(),
        thumbnailUrl = json[TransactionKey.thumbnailUrl],
        fileUrl = json[TransactionKey.fileUrl],
        filename = json[TransactionKey.fileName],
        aspectRatio = json[TransactionKey.aspectRatio],
        thumbnailStorageId = json[TransactionKey.thumbnailStorageId],
        originalFileStorageId = json[TransactionKey.originalFileStorageId],
        type = TransactionType.values.firstWhere(
          (transactionType) =>
              transactionType.name == json[TransactionKey.type],
          orElse: () => TransactionType.expense,
        );
  // tags = [
  //   for (final tag in json[TransactionKey.tags])
  //     Tag(
  //       tagId: tag[TagKey.tagId],
  //       tagName: tag[TagKey.tagName],
  //       tagColor: tag[TagKey.tagColor],
  //       tagIcon: tag[TagKey.tagIcon],
  //     ),
  // ],
  // shared = json[TransactionKey.shared],
  // isBookmark = json[TransactionKey.isBookmark];
}
