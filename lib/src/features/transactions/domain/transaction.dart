import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart' show Color;

import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction_image.dart';

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
  final String userId;
  final String walletId;
  final String walletName;
  final double amount;
  final String categoryName;
  final TransactionType type;
  final DateTime? createdAt;
  final DateTime date;
  final bool isBookmark;
  final String? description;
  final TransactionImage? transactionImage;
  final List<String> tags;

  const Transaction({
    required this.transactionId,
    required this.userId,
    required this.walletId,
    required this.walletName,
    required this.amount,
    required this.categoryName,
    required this.description,
    required this.type,
    required this.date,
    this.isBookmark = false,
    this.createdAt,
    this.transactionImage,
    this.tags = const [],
  });

  Transaction.fromJson({
    required String transactionId,
    required Map<String, dynamic> json,
  }) : this(
          transactionId: transactionId,
          userId: json[TransactionKey.userId],
          walletId: json[TransactionKey.walletId],
          walletName: json[TransactionKey.walletName],
          amount: json[TransactionKey.amount],
          categoryName: json[TransactionKey.categoryName],
          description: json[TransactionKey.description],
          type: TransactionType.values.firstWhere(
            (transactionType) =>
                transactionType.name == json[TransactionKey.type],
            orElse: () => TransactionType.expense,
          ),
          date: (json[TransactionKey.date] as Timestamp?)?.toDate() ??
              DateTime.now(),
          isBookmark: json[TransactionKey.isBookmark] ?? false,
          createdAt: (json[TransactionKey.createdAt] as Timestamp).toDate(),
          transactionImage: json[TransactionKey.transactionImage] != null
              ? TransactionImage.fromJson(
                  transactionId: transactionId,
                  json: json[TransactionKey.transactionImage],
                )
              : null,
          tags: json[TransactionKey.tags] != null
              ? (json[TransactionKey.tags] as List<dynamic>).cast<String>()
              : [],
        );

  Map<String, dynamic> toJson() => {
        TransactionKey.userId: userId,
        TransactionKey.walletId: walletId,
        TransactionKey.walletName: walletName,
        TransactionKey.amount: amount,
        TransactionKey.categoryName: categoryName,
        TransactionKey.type: type.name,
        TransactionKey.createdAt: FieldValue.serverTimestamp(),
        TransactionKey.date: date,
        TransactionKey.isBookmark: isBookmark,
        TransactionKey.description: description,
        if (transactionImage != null)
          TransactionKey.transactionImage: transactionImage!.toJson(),
        if (tags.isNotEmpty) TransactionKey.tags: tags,
      };

  Transaction copyWith({
    String? transactionId,
    String? userId,
    String? walletName,
    double? amount,
    String? categoryName,
    TransactionType? type,
    DateTime? createdAt,
    DateTime? date,
    bool? isBookmark,
    String? description,
    TransactionImage? transactionImage,
    List<String>? tags,
  }) =>
      Transaction(
        transactionId: transactionId ?? this.transactionId,
        userId: userId ?? this.userId,
        walletId: walletId,
        walletName: walletName ?? this.walletName,
        amount: amount ?? this.amount,
        categoryName: categoryName ?? this.categoryName,
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
        date: date ?? this.date,
        isBookmark: isBookmark ?? this.isBookmark,
        description: description ?? this.description,
        transactionImage: transactionImage ?? this.transactionImage,
        tags: tags ?? this.tags,
      );
}

@immutable
class TransactionKey {
  static const userId = 'uid';
  static const description = 'description';
  static const amount = 'amount';
  static const categoryName = 'categoryName'; // ! CHANGE to category_name
  static const type = 'type';
  static const createdAt = 'created_at';
  static const date = 'date';
  static const isBookmark = 'is_bookmark';
  static const thumbnailUrl = 'thumbnail_url';
  static const fileUrl = 'file_url';
  static const fileType = 'file_type';
  static const fileName = 'file_name';
  static const aspectRatio = 'aspect_ratio';
  static const thumbnailStorageId = 'thumbnail_storage_id';
  static const originalFileStorageId = 'original_file_storage_id';
  static const transactionImage = 'transaction_image';
  static const tags = 'tags';
  static const walletId = 'wallet_id';
  static const walletName = 'wallet_name';

  const TransactionKey._();
}
