import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart'
    show FieldPath, FirebaseFirestore;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/category/application/category_providers.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/timeline/bookmarks/application/bookmark_services.dart';
import 'package:pocketfi/src/features/timeline/transactions/application/transaction_providers.dart';
import 'package:pocketfi/src/features/timeline/transactions/date_picker/application/selected_date_notifier.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/shared/image_upload/exceptions/could_not_build_thumbnail_exception.dart';
import 'package:pocketfi/src/features/shared/image_upload/extensions/get_image_data_aspect_ratio.dart';
import 'package:pocketfi/src/features/shared/image_upload/image_constants.dart';
import 'package:pocketfi/src/utils/document_id_from_current_date.dart';
import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';

class TransactionTypeNotifier extends StateNotifier<TransactionType> {
  TransactionTypeNotifier() : super(TransactionType.expense);

  void setTransactionType(int index) {
    state = TransactionType.values[index];
  }

  void resetTransactionTypeState() {
    state = TransactionType.expense;
  }
}

// * SELECTED TRANSACTION
class SelectedTransactionNotifier extends StateNotifier<Transaction?> {
  SelectedTransactionNotifier(Transaction? transaction) : super(transaction);

  void setSelectedTransaction(Transaction transaction, WidgetRef ref) {
    // // if transaction is null, create a new transaction instance
    // state = Transaction.fromJson(
    //   transactionId: transaction.transactionId,
    //   json: transaction.toJson(),
    // );

    state = transaction;
  }

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

  void updateCategory(Category newCategory, WidgetRef ref) {
    Transaction? transaction = ref.watch(selectedTransactionProvider);
    if (transaction != null) {
      transaction = transaction.copyWith(categoryName: newCategory.name);
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

  void clearSelectedTransaction() {
    state = null;
  }
}

// * CREATE NEW TRANSACTION
void setNewTransactionState(WidgetRef ref) {
  //  this two is to reset DatePicker state
  ref.read(transactionDateProvider.notifier).setDate(DateTime.now());
  ref.read(selectedTransactionProvider.notifier).clearSelectedTransaction();
  //  this is to reset category state
  resetCategoryState(ref);
  //  this is to reset type state
  ref.read(transactionTypeProvider.notifier).resetTransactionTypeState();
  //  this is to reset photo state
  // ref.read(imageFileProvider.notifier).resetTransactionPhotoState();
  // this is to reset bookmark icon
  ref.read(isBookmarkProvider.notifier).resetBookmarkState();
}

class CreateNewTransactionNotifier extends StateNotifier<IsLoading> {
  CreateNewTransactionNotifier() : super(false);

  set isLoading(bool isLoading) => state = isLoading;

  Future<bool> createNewTransaction({
    required UserId userId,
    required double amount,
    required DateTime date,
    required TransactionType type,
    required String categoryName,
    required String walletId,
    required String walletName,
    required File? file,
    String? note,
    bool isBookmark = false,
  }) async {
    isLoading = true;

    debugPrint('createNewTransaction()');

    // FIXME temp solution to get the *first* wallet id
    // final walletId = await FirebaseFirestore.instance
    //     .collection(FirebaseCollectionName.users)
    //     .doc(userId)
    //     .collection(FirebaseCollectionName.wallets)
    //     .limit(1)
    //     .get()
    //     .then((value) => value.docs.first.id);

    final transactionId = documentIdFromCurrentDate();

    // final TransactionPayload payload;
    final Map<String, dynamic> payload;

    try {
      if (file == null) {
        // payload = TransactionPayload(
        //   userId: userId,
        //   amount: amount,
        //   date: date,
        //   type: type,
        //   categoryName: categoryName,
        //   description: note,
        // );
        payload = Transaction(
          transactionId: transactionId,
          userId: userId,
          walletId: walletId,
          walletName: walletName,
          amount: amount,
          date: date,
          type: type,
          categoryName: categoryName,
          description: note,
          isBookmark: isBookmark,
        ).toJson();
        debugPrint('no pic..');
      } else {
        late Uint8List thumbnailUint8List;
        // decode the image
        final fileAsImage = img.decodeImage(file.readAsBytesSync());
        if (fileAsImage == null) {
          isLoading = false;
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
        final originalFileUploadTask = await originalFileRef.putFile(file);
        final originalFileStorageId = originalFileUploadTask.ref.name;

        // payload = TransactionPayload(
        //   userId: userId,
        //   amount: amount,
        //   date: date,
        //   type: type,
        //   categoryName: categoryName,
        //   description: note,
        //   thumbnailUrl: await thumbnailRef.getDownloadURL(),
        //   fileUrl: await originalFileRef.getDownloadURL(),
        //   fileName: fileName,
        //   aspectRatio: thumbnailAspectRatio,
        //   thumbnailStorageId: thumbnailStorageId,
        //   originalFileStorageId: originalFileStorageId,
        // );

        // set the transaction in to payload  using toJson()
        payload = Transaction(
          transactionId: transactionId,
          userId: userId,
          walletId: walletId,
          walletName: walletName,
          amount: amount,
          date: date,
          isBookmark: isBookmark,
          // createdAt: DateTime.now(),
          type: type,
          categoryName: categoryName,
          description: note,
          thumbnailUrl: await thumbnailRef.getDownloadURL(),
          fileUrl: await originalFileRef.getDownloadURL(),
          fileName: fileName,
          aspectRatio: thumbnailAspectRatio,
          thumbnailStorageId: thumbnailStorageId,
          originalFileStorageId: originalFileStorageId,
        ).toJson();
      }
      debugPrint('uploading new transaction..');

      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(userId)
          .collection(FirebaseCollectionName.wallets)
          .doc(walletId)
          .collection(FirebaseCollectionName.transactions)
          .doc(transactionId)
          .set(payload);
      debugPrint('Transaction added $payload');

      return true;
    } catch (e) {
      debugPrint('Error adding transaction: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }
}

// * UPDATE TRANSACTION
class UpdateTransactionNotifier extends StateNotifier<IsLoading> {
  UpdateTransactionNotifier() : super(false);

  set isLoading(bool isLoading) => state = isLoading;

  Future<bool> updateTransaction({
    // required Transaction transaction,
    required String transactionId,
    required UserId userId,
    required double amount,
    required DateTime date,
    required TransactionType type,
    required String categoryName,
    required String walletId,
    required String walletName,
    required File? file,
    String? note,
    bool isBookmark = false,
  }) async {
    try {
      isLoading = true;

      // final querySnaptshot = FirebaseFirestore.instance
      //     .collection(FirebaseCollectionName.users)
      //     .doc(transaction.userId)
      //     .collection(FirebaseCollectionName.wallets)
      //     .doc(transaction.walletId)
      //     .collection(FirebaseCollectionName.transactions)
      //     .where(FieldPath.documentId, isEqualTo: transaction.transactionId)
      //     .limit(1)
      //     .get();
      final querySnaptshot = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(userId)
          .collection(FirebaseCollectionName.wallets)
          .doc(walletId)
          .collection(FirebaseCollectionName.transactions)
          .where(FieldPath.documentId, isEqualTo: transactionId)
          .limit(1)
          .get();

      await querySnaptshot.then((querySnaptshot) async {
        // for(final doc in querySnaptshot.docs){
        //   if ()
        // }
        final doc = querySnaptshot.docs.first;

        await doc.reference.update(
            // transaction.toJson(),

            {
              TransactionKey.amount: amount,
              TransactionKey.date: date,
              TransactionKey.type: type.name,
              TransactionKey.walletId: walletId,
              TransactionKey.walletName: walletName,
              TransactionKey.categoryName: categoryName,
              TransactionKey.description: note,
              TransactionKey.isBookmark: isBookmark,
            });

        // await Future.delayed(const Duration(milliseconds: 100));
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<bool> toogleBookmark({
    required Transaction transaction,
  }) async {
    try {
      isLoading = true;

      final querySnaptshot = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(transaction.userId)
          .collection(FirebaseCollectionName.wallets)
          .doc(transaction.walletId)
          .collection(FirebaseCollectionName.transactions)
          .where(FieldPath.documentId, isEqualTo: transaction.transactionId)
          .limit(1)
          .get();

      await querySnaptshot.then((querySnaptshot) async {
        final doc = querySnaptshot.docs.first;

        await doc.reference.update({
          TransactionKey.isBookmark: !transaction.isBookmark,
        });

        // await Future.delayed(const Duration(milliseconds: 100));
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      isLoading = false;
    }
  }
}

// * DELETE TRANSACTION
class DeleteTransactionNotifier extends StateNotifier<IsLoading> {
  DeleteTransactionNotifier() : super(false);

  set isLoading(bool isLoading) => state = isLoading;

  Future<bool> deleteTransaction({
    required String transactionId,
    required UserId userId,
    required String walletId,
  }) async {
    try {
      isLoading = true;

      // final querySnaptshot = FirebaseFirestore.instance
      //     .collection(FirebaseCollectionName.users)
      //     .doc(transaction.userId)
      //     .collection(FirebaseCollectionName.wallets)
      //     .doc(transaction.walletId)
      //     .collection(FirebaseCollectionName.transactions)
      //     .where(FieldPath.documentId, isEqualTo: transaction.transactionId)
      //     .limit(1)
      //     .get();
      final querySnaptshot = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(userId)
          // .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(FirebaseCollectionName.wallets)
          .doc(walletId)
          .collection(FirebaseCollectionName.transactions)
          .where(FieldPath.documentId, isEqualTo: transactionId)
          .limit(1)
          .get();

      await querySnaptshot.then((querySnaptshot) async {
        // for(final doc in querySnaptshot.docs){
        //   if ()
        // }
        final doc = querySnaptshot.docs.first;

        await doc.reference.delete();

        await Future.delayed(const Duration(milliseconds: 100));
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      isLoading = false;
    }
  }
}
