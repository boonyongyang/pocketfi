import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/category/application/category_services.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/shared/image_upload/data/image_file_notifier.dart';
import 'package:pocketfi/src/features/shared/image_upload/exceptions/could_not_build_thumbnail_exception.dart';
import 'package:pocketfi/src/features/shared/image_upload/extensions/get_image_data_aspect_ratio.dart';
import 'package:pocketfi/src/features/shared/image_upload/image_constants.dart';
import 'package:pocketfi/src/features/bookmarks/application/bookmark_services.dart';
import 'package:pocketfi/src/features/tags/application/tag_services.dart';
import 'package:pocketfi/src/features/shared/date_picker/application/date_services.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/transactions/data/transaction_repository.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction_image.dart';
import 'package:uuid/uuid.dart';

// * transactionTypeProvider
final transactionTypeProvider =
    StateNotifierProvider<TransactionTypeNotifier, TransactionType>(
        (ref) => TransactionTypeNotifier());

// * transactionTypeNotifier
class TransactionTypeNotifier extends StateNotifier<TransactionType> {
  TransactionTypeNotifier() : super(TransactionType.expense);

  void setTransactionType(int index) {
    state = TransactionType.values[index];
  }

  void resetTransactionTypeState() {
    state = TransactionType.expense;
  }
}

// * addNewTransaction
void setNewTransactionState(WidgetRef ref) {
  //  this two is to reset DatePicker state
  ref.read(transactionDateProvider.notifier).setDate(DateTime.now());
  ref
      .read(selectedTransactionProvider.notifier)
      .resetSelectedTransactionState();
  //  this is to reset category state
  resetCategoryState(ref);
  //  this is to reset type state
  ref.read(transactionTypeProvider.notifier).resetTransactionTypeState();
  //  this is to reset photo state
  ref.read(imageFileProvider.notifier).clearImageFile();
  // this is to reset bookmark icon
  ref.read(isBookmarkProvider.notifier).resetBookmarkState();
  // this is to reset tags
  ref.read(userTagsNotifier.notifier).resetTagsState(ref);
}

// * transactionProvider
final transactionProvider =
    StateNotifierProvider<TransactionNotifier, IsLoading>(
        (ref) => TransactionNotifier());

// * selectedTransactionProvider
final selectedTransactionProvider =
    StateNotifierProvider<SelectedTransactionNotifier, Transaction?>(
  (_) => SelectedTransactionNotifier(null),
);

// * SelectedTransaction
class SelectedTransactionNotifier extends StateNotifier<Transaction?> {
  SelectedTransactionNotifier(Transaction? transaction) : super(transaction);

  void setSelectedTransaction(Transaction transaction) => state = transaction;

  void resetSelectedTransactionState() => state = null;

  void updateTransactionDate(DateTime newDate, WidgetRef ref) {
    Transaction? transaction = ref.watch(selectedTransactionProvider);
    if (transaction != null) {
      transaction = transaction.copyWith(date: newDate);
      state = transaction;
    }
  }

  void updateTransactionType(int newIndex, WidgetRef ref) {
    Transaction? transaction = ref.watch(selectedTransactionProvider);
    if (transaction != null) {
      transaction =
          transaction.copyWith(type: TransactionType.values[newIndex]);
      state = transaction;
    }
  }

  void updateCategory(Category? newCategory, WidgetRef ref) {
    Transaction? transaction = ref.watch(selectedTransactionProvider);
    if (transaction != null) {
      transaction = transaction.copyWith(
          // categoryName: newCategory?.name ?? transaction.categoryName);
          categoryName: newCategory?.name ?? '');
      state = transaction;
    }
  }

  void toggleBookmark(WidgetRef ref) {
    Transaction? transaction = ref.watch(selectedTransactionProvider);
    if (transaction != null) {
      transaction = transaction.copyWith(isBookmark: !transaction.isBookmark);
      state = transaction;
    }
  }

  void removeTransactionImage(WidgetRef ref) {
    Transaction? transaction = ref.read(selectedTransactionProvider);
    if (transaction != null) {
      transaction = transaction.copyWith(transactionImage: null);
      state = transaction;
      debugPrint('state is now ${state?.transactionImage?.fileUrl}');
    }
  }

  Future<void> updateTransactionPhoto(File? newFile, WidgetRef ref) async {
    Transaction? transaction = ref.watch(selectedTransactionProvider);
    final userId = ref.read(userIdProvider)!;

    if (transaction != null) {
      TransactionImage? transactionImage;

      if (newFile != null) {
        late Uint8List thumbnailUint8List;
        // decode the image
        final fileAsImage = img.decodeImage(newFile.readAsBytesSync());
        if (fileAsImage == null) {
          // isLoading = false;
          // return false;
          throw const CouldNotBuildThumbnailException();
        }

        // create thumbnail
        final thumbnail = img.copyResize(
          fileAsImage,
          // width: Constants.imageThumbnailWidth,
          height: ImageConstants.imageThumbnailHeight,
        );
        // encode the thumbnail
        final thumbnailData = img.encodeJpg(thumbnail);
        // convert the thumbnail to a Uint8List
        thumbnailUint8List = Uint8List.fromList(thumbnailData);

        // calculate the aspect ratio
        final thumbnailAspectRatio = await thumbnailUint8List.getAspectRatio();

        // calculate references
        final fileName = const Uuid().v4();

        // create references to the thumbnail and the image itself
        final thumbnailRef = FirebaseStorage.instance
            .ref()
            .child(userId)
            .child('transactions')
            .child(FirebaseCollectionName.thumbnails)
            .child(fileName);

        // create references to the original file in
        final originalFileRef = FirebaseStorage.instance
            .ref()
            .child(userId)
            .child('transactions')
            .child('images')
            .child(fileName);

        // upload the thumbnail
        final thumbnailUploadTask =
            await thumbnailRef.putData(thumbnailUint8List);
        final thumbnailStorageId = thumbnailUploadTask.ref.name;

        // upload the original file
        final originalFileUploadTask = await originalFileRef.putFile(newFile);
        final originalFileStorageId = originalFileUploadTask.ref.name;

        transactionImage = TransactionImage(
          transactionId: transaction.transactionId,
          thumbnailUrl: await thumbnailRef.getDownloadURL(),
          fileUrl: await originalFileRef.getDownloadURL(),
          fileName: fileName,
          aspectRatio: thumbnailAspectRatio,
          thumbnailStorageId: thumbnailStorageId,
          originalFileStorageId: originalFileStorageId,
        );
      } else {
        transactionImage = null;
      }

      transaction = transaction.copyWith(
        transactionImage: transactionImage,
      );
      state = transaction;
    }
  }
}

final scheduledTransactionsProvider =
    Provider.autoDispose<List<Transaction>>((ref) {
  final transactionList = ref.watch(userTransactionsProvider);
  if (transactionList.hasValue) {
    final transactions = transactionList.value ?? [];
    final tomorrow = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
    return transactions.where((transaction) {
      final transactionDate = DateTime(
          transaction.date.year, transaction.date.month, transaction.date.day);
      return transactionDate.isAfter(tomorrow) || transactionDate == tomorrow;
    }).toList();
  }
  return [];
});
