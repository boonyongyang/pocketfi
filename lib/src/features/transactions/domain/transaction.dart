// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  // final String? thumbnailUrl; // image
  // final String? fileUrl; // image
  // final String? fileName; // image
  // final double? aspectRatio; // image
  // final String? thumbnailStorageId; // image
  // final String? originalFileStorageId; // image
  final TransactionImage? transactionImage;
  // final Receipt? receipt;
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
    // this.receipt,
    // this.thumbnailUrl,
    // this.fileUrl,
    // this.fileName,
    // this.aspectRatio,
    // this.thumbnailStorageId,
    // this.originalFileStorageId,
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
          // tags: json[TransactionKey.tags] != null
          //     ? (json[TransactionKey.tags] as List<dynamic>)
          //         .map((tag) => Tag.fromJson(
          //               name: tag[TagKey.name],
          //               json: json[TransactionKey.tags],
          //             ))
          //         .toList()
          //     : [],
          tags: json[TransactionKey.tags] != null
              ? (json[TransactionKey.tags] as List<dynamic>).cast<String>()
              : [],
          // receipt: json[TransactionKey.receipt] != null
          //     ? Receipt.fromJson(
          //         transactionId: transactionId,
          //         json: json[TransactionKey.receipt],
          //       )
          //     : null,
          // thumbnailUrl: json[TransactionKey.thumbnailUrl],
          // fileUrl: json[TransactionKey.fileUrl],
          // fileName: json[TransactionKey.fileName],
          // aspectRatio: json[TransactionKey.aspectRatio],
          // thumbnailStorageId: json[TransactionKey.thumbnailStorageId],
          // originalFileStorageId: json[TransactionKey.originalFileStorageId],
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
        // TransactionKey.thumbnailUrl: thumbnailUrl,
        // TransactionKey.fileUrl: fileUrl,
        // TransactionKey.fileName: fileName,
        // TransactionKey.aspectRatio: aspectRatio,
        // TransactionKey.thumbnailStorageId: thumbnailStorageId,
        // TransactionKey.originalFileStorageId: originalFileStorageId,
        if (transactionImage != null)
          TransactionKey.transactionImage: transactionImage!.toJson(),
        // if (receipt != null) TransactionKey.receipt: receipt!.toJson(),
        if (tags.isNotEmpty)
          // TransactionKey.tags: tags.map((tag) => tag.toJson()).toList(),
          TransactionKey.tags: tags,
      };

  Transaction copyWith({
    String? transactionId,
    String? userId,
    // String? walletId,
    String? walletName,
    double? amount,
    String? categoryName,
    TransactionType? type,
    DateTime? createdAt,
    DateTime? date,
    bool? isBookmark,
    String? description,
    // String? thumbnailUrl,
    // String? fileUrl,
    // String? fileName,
    // double? aspectRatio,
    // String? thumbnailStorageId,
    // String? originalFileStorageId,
    TransactionImage? transactionImage,
    // Receipt? receipt,
    List<String>? tags,
  }) =>
      Transaction(
        transactionId: transactionId ?? this.transactionId,
        userId: userId ?? this.userId,
        // walletId: walletId ?? this.walletId,
        walletId: walletId, // should not change walletId like that
        walletName: walletName ?? this.walletName,
        amount: amount ?? this.amount,
        categoryName: categoryName ?? this.categoryName,
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
        date: date ?? this.date,
        isBookmark: isBookmark ?? this.isBookmark,
        description: description ?? this.description,
        // thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        // fileUrl: fileUrl ?? this.fileUrl,
        // fileName: fileName ?? this.fileName,
        // aspectRatio: aspectRatio ?? this.aspectRatio,
        // thumbnailStorageId: thumbnailStorageId ?? this.thumbnailStorageId,
        // originalFileStorageId:
        //     originalFileStorageId ?? this.originalFileStorageId,
        transactionImage: transactionImage ?? this.transactionImage,
        // receipt: receipt ?? this.receipt,
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
  // static const receipt = 'receipt';
  static const tags = 'tags';
  // static const shared = 'shared';

  static const walletId = 'wallet_id';
  static const walletName = 'wallet_name';

  const TransactionKey._();
}
