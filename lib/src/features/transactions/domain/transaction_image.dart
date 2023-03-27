import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';

@immutable
class TransactionImage {
  final String transactionId;
  final String? thumbnailUrl;
  final String? fileUrl;
  final String? fileName;
  final double? aspectRatio;
  final String? thumbnailStorageId;
  final String? originalFileStorageId;

  const TransactionImage({
    required this.transactionId,
    required this.thumbnailUrl,
    required this.fileUrl,
    required this.fileName,
    required this.aspectRatio,
    required this.thumbnailStorageId,
    required this.originalFileStorageId,
  });

  TransactionImage.fromJson({
    required String transactionId,
    required Map<String, dynamic> json,
  }) : this(
          transactionId: transactionId,
          thumbnailUrl: json[TransactionKey.thumbnailUrl],
          fileUrl: json[TransactionKey.fileUrl],
          fileName: json[TransactionKey.fileName],
          aspectRatio: json[TransactionKey.aspectRatio],
          thumbnailStorageId: json[TransactionKey.thumbnailStorageId],
          originalFileStorageId: json[TransactionKey.originalFileStorageId],
        );

  Map<String, dynamic> toJson() => {
        TransactionKey.thumbnailUrl: thumbnailUrl,
        TransactionKey.fileUrl: fileUrl,
        TransactionKey.fileName: fileName,
        TransactionKey.aspectRatio: aspectRatio,
        TransactionKey.thumbnailStorageId: thumbnailStorageId,
        TransactionKey.originalFileStorageId: originalFileStorageId,
      };
}
