import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart'
    show FieldPath, FirebaseFirestore;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/category/application/category_providers.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/shared/image_upload/data/image_file_notifier.dart';
import 'package:pocketfi/src/features/timeline/bookmarks/application/bookmark_services.dart';
import 'package:pocketfi/src/features/timeline/transactions/application/transaction_providers.dart';
import 'package:pocketfi/src/features/timeline/transactions/date_picker/application/selected_date_notifier.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/shared/image_upload/exceptions/could_not_build_thumbnail_exception.dart';
import 'package:pocketfi/src/features/shared/image_upload/extensions/get_image_data_aspect_ratio.dart';
import 'package:pocketfi/src/features/shared/image_upload/image_constants.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction_image.dart';
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

  // set selectedTransaction(Transaction? transaction) => state = transaction;

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

// * CREATE NEW TRANSACTION
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

    final transactionId = documentIdFromCurrentDate();

    try {
      final Map<String, dynamic> payload;
      if (file == null) {
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
          transactionImage: null,
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

        // set the transaction in to payload  using toJson()
        payload = Transaction(
            transactionId: transactionId,
            userId: userId,
            walletId: walletId,
            walletName: walletName,
            amount: amount,
            date: date,
            isBookmark: isBookmark,
            type: type,
            categoryName: categoryName,
            description: note,
            // thumbnailUrl: await thumbnailRef.getDownloadURL(),
            // fileUrl: await originalFileRef.getDownloadURL(),
            // fileName: fileName,
            // aspectRatio: thumbnailAspectRatio,
            // thumbnailStorageId: thumbnailStorageId,
            // originalFileStorageId: originalFileStorageId,
            transactionImage: TransactionImage(
              transactionId: transactionId,
              thumbnailUrl: await thumbnailRef.getDownloadURL(),
              fileUrl: await originalFileRef.getDownloadURL(),
              fileName: fileName,
              aspectRatio: thumbnailAspectRatio,
              thumbnailStorageId: thumbnailStorageId,
              originalFileStorageId: originalFileStorageId,
            )).toJson();
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
    required String transactionId,
    required UserId userId,
    required double amount,
    required DateTime date,
    required TransactionType type,
    required String categoryName,
    required String originalWalletId,
    required String newWalletId,
    required String walletName,
    required File? file,
    String? note,
    bool isBookmark = false,
  }) async {
    try {
      isLoading = true;
      debugPrint('updating ..');
      debugPrint('image is  $file');

      // if new walletId is different from the original walletId
      // then delete the transaction from the original wallet
      // and add it to the new wallet
      if (originalWalletId != newWalletId) {
        // delete the transaction from the original wallet
        await FirebaseFirestore.instance
            .collection(FirebaseCollectionName.users)
            .doc(userId)
            .collection(FirebaseCollectionName.wallets)
            .doc(originalWalletId)
            .collection(FirebaseCollectionName.transactions)
            .doc(transactionId)
            .delete();

        // add the transaction to the new wallet
        final Map<String, dynamic> payload;

        if (file == null) {
          payload = Transaction(
            transactionId: transactionId,
            userId: userId,
            walletId: newWalletId,
            walletName: walletName,
            amount: amount,
            date: date,
            type: type,
            categoryName: categoryName,
            description: note,
            isBookmark: isBookmark,
            transactionImage: null,
          ).toJson();
          debugPrint('no pic..');
        } else {
          // late Uint8List thumbnailUint8List;
          // // decode the image
          // final fileAsImage = img.decodeImage(file.readAsBytesSync());
          // if (fileAsImage == null) {
          //   isLoading = false;
          //   // return false;
          //   throw const CouldNotBuildThumbnailException();
          // }

          // final thumbnail = img.copyResize(
          //   fileAsImage,
          //   height: ImageConstants.imageThumbnailHeight,
          // );
          // final thumbnailData = img.encodeJpg(thumbnail);
          // thumbnailUint8List = Uint8List.fromList(thumbnailData);

          // final thumbnailAspectRatio =
          //     await thumbnailUint8List.getAspectRatio();

          // final fileName = const Uuid().v4();

          // final thumbnailRef = FirebaseStorage.instance
          //     .ref()
          //     .child(userId)
          //     .child('transactions')
          //     .child(FirebaseCollectionName.thumbnails)
          //     .child(fileName);

          // final originalFileRef = FirebaseStorage.instance
          //     .ref()
          //     .child(userId)
          //     .child('transactions')
          //     .child('images')
          //     .child(fileName);

          // final thumbnailUploadTask =
          //     await thumbnailRef.putData(thumbnailUint8List);
          // final thumbnailStorageId = thumbnailUploadTask.ref.name;

          // final originalFileUploadTask = await originalFileRef.putFile(file);
          // final originalFileStorageId = originalFileUploadTask.ref.name;

          payload = Transaction(
            transactionId: transactionId,
            userId: userId,
            walletId: newWalletId,
            walletName: walletName,
            amount: amount,
            date: date,
            isBookmark: isBookmark,
            type: type,
            categoryName: categoryName,
            description: note,
            // thumbnailUrl: await thumbnailRef.getDownloadURL(),
            // fileUrl: await originalFileRef.getDownloadURL(),
            // fileName: fileName,
            // aspectRatio: thumbnailAspectRatio,
            // thumbnailStorageId: thumbnailStorageId,
            // originalFileStorageId: originalFileStorageId,
            // * failed to update transaction with image
            // transactionImage: TransactionImage(
            //   transactionId: transactionId,
            //   thumbnailUrl: await thumbnailRef.getDownloadURL(),
            //   fileUrl: await originalFileRef.getDownloadURL(),
            //   fileName: fileName,
            //   aspectRatio: thumbnailAspectRatio,
            //   thumbnailStorageId: thumbnailStorageId,
            //   originalFileStorageId: originalFileStorageId,
            // ),
          ).toJson();
        }
        debugPrint('uploading new transaction..');

        await FirebaseFirestore.instance
            .collection(FirebaseCollectionName.users)
            .doc(userId)
            .collection(FirebaseCollectionName.wallets)
            .doc(newWalletId)
            .collection(FirebaseCollectionName.transactions)
            .doc(transactionId)
            .set(payload);
        debugPrint('Transaction added $payload');
      } else {
        // update the transaction in the same wallet
        await FirebaseFirestore.instance
            .collection(FirebaseCollectionName.users)
            .doc(userId)
            .collection(FirebaseCollectionName.wallets)
            .doc(originalWalletId)
            .collection(FirebaseCollectionName.transactions)
            .doc(transactionId)
            .update({
          TransactionKey.amount: amount,
          TransactionKey.date: date,
          TransactionKey.type: type.name,
          TransactionKey.walletId: newWalletId,
          TransactionKey.walletName: walletName,
          TransactionKey.categoryName: categoryName,
          TransactionKey.description: note,
          TransactionKey.isBookmark: isBookmark,
          // TransactionKey.transactionImage: file == null
          //     ? null
          //     : {
          //         TransactionKey.thumbnailUrl: await FirebaseStorage.instance
          //             .ref()
          //             .child(userId)
          //             .child('transactions')
          //             .child(FirebaseCollectionName.thumbnails)
          //             .child(const Uuid().v4())
          //             .getDownloadURL(),
          //         TransactionKey.fileUrl: await FirebaseStorage.instance
          //             .ref()
          //             .child(userId)
          //             .child('transactions')
          //             .child('images')
          //             .child(const Uuid().v4())
          //             .getDownloadURL(),
          //         TransactionKey.fileName: const Uuid().v4(),
          //         TransactionKey.aspectRatio:
          //             await file.readAsBytesSync().getAspectRatio(),
          //         TransactionKey.thumbnailStorageId: const Uuid().v4(),
          //         TransactionKey.originalFileStorageId: const Uuid().v4(),
          //       }
        });
        debugPrint('Transaction updated');
      }

      // final querySnaptshot = FirebaseFirestore.instance
      //     .collection(FirebaseCollectionName.users)
      //     .doc(userId)
      //     .collection(FirebaseCollectionName.wallets)
      //     .doc(newWalletId)
      //     .collection(FirebaseCollectionName.transactions)
      //     .where(FieldPath.documentId, isEqualTo: transactionId)
      //     .limit(1)
      //     .get();

      // await querySnaptshot.then((querySnaptshot) async {
      //   final doc = querySnaptshot.docs.first;

      //   await doc.reference.update({
      //     TransactionKey.amount: amount,
      //     TransactionKey.date: date,
      //     TransactionKey.type: type.name,
      //     TransactionKey.walletId: newWalletId,
      //     TransactionKey.walletName: walletName,
      //     TransactionKey.categoryName: categoryName,
      //     TransactionKey.description: note,
      //     TransactionKey.isBookmark: isBookmark,
      //   });
      // });

      // await Future.delayed(const Duration(milliseconds: 2000));

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
        final doc = querySnaptshot.docs.first;

        await doc.reference.delete();

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
