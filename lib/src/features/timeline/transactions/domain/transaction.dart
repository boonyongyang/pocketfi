import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart' show Color;
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction_key.dart';

enum TransactionType {
  expense(
    symbol: Strings.expenseSymbol,
    color: Color(AppColors.expenseColor),
  ),
  income(
    symbol: Strings.incomeSymbol,
    color: Color(AppColors.incomeColor),
  ),
  transfer(
    symbol: Strings.transferSymbol,
    color: Color(AppColors.transferColor),
  );

  final String symbol;
  final Color color;

  const TransactionType({
    required this.symbol,
    required this.color,
  });
}

@immutable
class Transaction {
  final String transactionId;
  // final String userId;
  final double amount;
  final String categoryName;
  final TransactionType type;
  final DateTime createdAt;
  final DateTime date;
  final bool isBookmark;
  final String? description;
  final String? thumbnailUrl; // image
  final String? fileUrl; // image
  final String? filename; // image
  final double? aspectRatio; // image
  final String? thumbnailStorageId; // image
  final String? originalFileStorageId; // image
  // final List<Tag> tags;

  Transaction({
    required this.transactionId,
    required Map<String, dynamic> json,
  })  :
        // userId = json[TransactionKey.userId],
        amount = json[TransactionKey.amount],
        // categoryName = Category.fromJson(json[TransactionKey.category]),
        categoryName = json[TransactionKey.categoryName],
        description = json[TransactionKey.description],
        type = TransactionType.values.firstWhere(
          (transactionType) =>
              transactionType.name == json[TransactionKey.type],
          orElse: () => TransactionType.expense,
        ),
        date = (json[TransactionKey.date] as Timestamp?)?.toDate() ??
            DateTime.now(),
        isBookmark = json[TransactionKey.isBookmark] ?? false,
        createdAt = (json[TransactionKey.createdAt] as Timestamp).toDate(),
        thumbnailUrl = json[TransactionKey.thumbnailUrl],
        fileUrl = json[TransactionKey.fileUrl],
        filename = json[TransactionKey.fileName],
        aspectRatio = json[TransactionKey.aspectRatio],
        thumbnailStorageId = json[TransactionKey.thumbnailStorageId],
        originalFileStorageId = json[TransactionKey.originalFileStorageId];
  // tags = [
  //   for (final tag in json[TransactionKey.tags])
  //     Tag(
  //       tagId: tag['tagId'],
  //       tagName: tag['tagName'],
  //       tagColor: tag['tagColor'],
  //       tagIcon: tag['tagIcon'],
  //     ),
  // ];
}
