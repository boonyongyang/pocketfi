import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart'
    show FieldPath, FirebaseFirestore;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/receipts/domain/receipt_text_rect.dart';
import 'package:pocketfi/src/features/transactions/date_picker/application/transaction_date_services.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/shared/image_upload/exceptions/could_not_build_thumbnail_exception.dart';
import 'package:pocketfi/src/features/shared/image_upload/extensions/get_image_data_aspect_ratio.dart';
import 'package:pocketfi/src/features/shared/image_upload/image_constants.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction_image.dart';
import 'package:pocketfi/src/features/wallets/application/wallet_visibility.dart';
import 'package:pocketfi/src/features/wallets/data/wallet_repository.dart';
import 'package:pocketfi/src/utils/document_id_from_current_date.dart';
import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';

// * get all transactions from all wallets
final userTransactionsProvider =
    StreamProvider.autoDispose<Iterable<Transaction>>(
  (ref) {
    final wallets = ref.watch(userWalletsProvider).value;
    final controller = StreamController<Iterable<Transaction>>();

    // final transactionList =
    //     <Transaction>[]; // accumulate all transactions in a list
    final subscriptions = <StreamSubscription>[]; // store all subscriptions

    // get all transactions from all wallets
    final stream = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.transactions)
        .where(
          FirebaseFieldName.walletId,
          whereIn: wallets!.map((wallet) => wallet.walletId).toList(),
        )
        .orderBy(FirebaseFieldName.date, descending: true)
        .snapshots();

    final sub = stream.listen((snapshot) {
      final documents =
          snapshot.docs.where((doc) => !doc.metadata.hasPendingWrites);
      final transactions = documents.map(
        (doc) => Transaction.fromJson(
          transactionId: doc.id,
          json: doc.data(),
        ),
      );
      //   transactionList
      //       .addAll(transactions); // add transactions to the accumulated list
      //   controller.sink.add(transactionList);

      // Create a new list for updated transactions
      final updatedTransactionList = [
        ...transactions,
      ];
      controller.sink.add(updatedTransactionList);
    });
    subscriptions.add(sub); // add the subscription to the list

    ref.onDispose(() {
      for (var sub in subscriptions) {
        sub.cancel();
      }
      controller.close();
    });

    return controller.stream;
  },
);

// * get user transactions by month, based on month
final userTransactionsByMonthProvider =
    StreamProvider.autoDispose<Iterable<Transaction>>(
  (ref) {
    final wallets = ref.watch(userWalletsProvider).value;
    final month = ref.watch(overviewMonthProvider);
    final controller = StreamController<Iterable<Transaction>>();

    // final transactionList =
    //     <Transaction>[]; // accumulate all transactions in a list
    final subscriptions = <StreamSubscription>[]; // store all subscriptions

    // get all transactions from all wallets
    final stream = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.transactions)
        .where(
          FirebaseFieldName.walletId,
          whereIn: wallets!.map((wallet) => wallet.walletId).toList(),
        )
        .orderBy(FirebaseFieldName.date, descending: true)
        .snapshots();

    final sub = stream.listen((snapshot) {
      final documents =
          snapshot.docs.where((doc) => !doc.metadata.hasPendingWrites);
      final transactions = documents
          .map(
            (doc) => Transaction.fromJson(
              transactionId: doc.id,
              json: doc.data(),
            ),
          )
          .where((transaction) => transaction.date.month == month.month);

      // transactionList
      //     .addAll(transactions); // add transactions to the accumulated list
      // controller.sink.add(transactionList);

      // Create a new list for updated transactions
      final updatedTransactionList = [
        ...transactions,
      ];
      controller.sink.add(updatedTransactionList);
    });
    subscriptions.add(sub); // add the subscription to the list

    ref.onDispose(() {
      for (var sub in subscriptions) {
        sub.cancel();
      }
      controller.close();
    });

    return controller.stream;
  },
);

// * get user transactions by month, based on month, based on WalletVisibility
final userTransactionsByMonthByWalletProvider =
    StreamProvider.autoDispose<Iterable<Transaction>>(
  (ref) {
    final wallets = ref.watch(userWalletsProvider).value;
    final month = ref.watch(overviewMonthProvider);
    final walletVisibility = ref.watch(walletVisibilityProvider);
    final controller = StreamController<Iterable<Transaction>>();

    final subscriptions = <StreamSubscription>[]; // store all subscriptions

    // get all transactions from all wallets
    final stream = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.transactions)
        .where(
          FirebaseFieldName.walletId,
          whereIn: wallets!.map((wallet) => wallet.walletId).toList(),
        )
        .orderBy(FirebaseFieldName.date, descending: true)
        .snapshots();

    final sub = stream.listen((snapshot) {
      final documents =
          snapshot.docs.where((doc) => !doc.metadata.hasPendingWrites);
      final transactions = documents
          .map(
            (doc) => Transaction.fromJson(
              transactionId: doc.id,
              json: doc.data(),
            ),
          )
          .where((transaction) {
            // Get the walletId of the current transaction
            final walletId = transaction.walletId;
            // Find the corresponding wallet from walletVisibility
            final wallet = wallets.firstWhere(
              (wallet) => wallet.walletId == walletId,
              // orElse: () => null,
            );
            // If the wallet is not found or its visibility is true, include the transaction
            return walletVisibility[wallet] == true;
          })
          .where((transaction) => transaction.date.month == month.month)
          // exclude transactions that are after today's date
          // .where((transaction) => transaction.date.isBefore(DateTime.now()));
          .where((transaction) {
            final today = DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day);
            final transactionDate = DateTime(transaction.date.year,
                transaction.date.month, transaction.date.day);
            return !transactionDate.isAfter(today);
          }); // Exclude scheduled transactions

      // Create a new list for updated transactions
      final updatedTransactionList = [
        ...transactions,
      ];

      controller.sink.add(updatedTransactionList);
    });
    subscriptions.add(sub); // add the subscription to the list

    ref.onDispose(() {
      for (var sub in subscriptions) {
        sub.cancel();
      }
      controller.close();
    });

    return controller.stream;
  },
);

final userTransactionsInWalletProvider =
    StreamProvider.autoDispose.family<Iterable<Transaction>, String>(
  (ref, String walletId) {
    final userId = ref.watch(userIdProvider);
    final controller = StreamController<Iterable<Transaction>>();

    controller.onListen = () {
      controller.sink.add([]);
    };

    debugPrint(userId);

    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.transactions)
        .where(TransactionKey.userId, isEqualTo: userId)
        .where(TransactionKey.walletId, isEqualTo: walletId)
        .orderBy(TransactionKey.date, descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        final documents = snapshot.docs;
        final transactions = documents
            .where(
              (doc) => !doc.metadata.hasPendingWrites,
            )
            .map(
              (doc) => Transaction.fromJson(
                transactionId: doc.id,
                json: doc.data(),
              ),
            );
        controller.sink.add(transactions);
      },
    );
    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });
    return controller.stream;
  },
);

final userTransactionsInBudgetProvider =
    StreamProvider.autoDispose.family<Iterable<Transaction>, String>(
  (ref, String budgetId) {
    final userId = ref.watch(userIdProvider);
    final controller = StreamController<Iterable<Transaction>>();

    controller.onListen = () {
      controller.sink.add([]);
    };

    debugPrint(userId);

    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.transactions)
        .where(TransactionKey.userId, isEqualTo: userId)
        .where(FirebaseFieldName.budgetId, isEqualTo: budgetId)
        .orderBy(TransactionKey.date, descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        final documents = snapshot.docs;
        final transactions = documents
            .where(
              (doc) => !doc.metadata.hasPendingWrites,
            )
            .map(
              (doc) => Transaction.fromJson(
                transactionId: doc.id,
                json: doc.data(),
              ),
            );
        controller.sink.add(transactions);
      },
    );
    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });
    return controller.stream;
  },
);

class TransactionNotifier extends StateNotifier<IsLoading> {
  TransactionNotifier() : super(false);

  set isLoading(bool isLoading) => state = isLoading;

// * add new transaction in AddNewTransaction
  Future<bool> addNewReceiptTransaction({
    required UserId userId,
    required double amount,
    required DateTime date,
    required TransactionType type,
    required String categoryName,
    required String walletId,
    required String walletName,
    required String imagePath,
    required RecognizedText recognizedText,
    required List<ReceiptTextRect> extractedTextRects,
    // required Receipt? receipt,
    String? merchant,
    String? note,
    bool isBookmark = false,
  }) async {
    isLoading = true;

    debugPrint('createNewTransaction()');

    final transactionId = documentIdFromCurrentDate();
    final imageFile = File(imagePath);

    try {
      final Map<String, dynamic> payload;
      late Uint8List thumbnailUint8List;
      // decode the image
      final fileAsImage = img.decodeImage(imageFile.readAsBytesSync());
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
      final originalFileUploadTask = await originalFileRef.putFile(imageFile);
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
        // receipt: Receipt(
        //   transactionId: transactionId,
        //   amount: amount,
        //   date: date,
        //   // file: imageFile,
        //   merchant: merchant,
        //   note: note,
        //   scannedText: recognizedText.text,
        //   extractedTextRects: extractedTextRects,
        //   transactionImage: TransactionImage(
        //     transactionId: transactionId,
        //     thumbnailUrl: await thumbnailRef.getDownloadURL(),
        //     fileUrl: await originalFileRef.getDownloadURL(),
        //     fileName: fileName,
        //     aspectRatio: thumbnailAspectRatio,
        //     thumbnailStorageId: thumbnailStorageId,
        //     originalFileStorageId: originalFileStorageId,
        //   ),
        // ),
        transactionImage: TransactionImage(
          transactionId: transactionId,
          thumbnailUrl: await thumbnailRef.getDownloadURL(),
          fileUrl: await originalFileRef.getDownloadURL(),
          fileName: fileName,
          aspectRatio: thumbnailAspectRatio,
          thumbnailStorageId: thumbnailStorageId,
          originalFileStorageId: originalFileStorageId,
        ),
      ).toJson();

      debugPrint('uploading new transaction..');
      debugPrint('payload: $payload');

      await FirebaseFirestore.instance
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

  Future<bool> addNewTransaction({
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

// * update transaction
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
      // if (originalWalletId != newWalletId) {
      //   // delete the transaction from the original wallet
      //   await FirebaseFirestore.instance
      //       .collection(FirebaseCollectionName.users)
      //       .doc(userId)
      //       .collection(FirebaseCollectionName.wallets)
      //       .doc(originalWalletId)
      //       .collection(FirebaseCollectionName.transactions)
      //       .doc(transactionId)
      //       .delete();

      //   // add the transaction to the new wallet
      //   final Map<String, dynamic> payload;

      //   if (file == null) {
      //     payload = Transaction(
      //       transactionId: transactionId,
      //       userId: userId,
      //       walletId: newWalletId,
      //       walletName: walletName,
      //       amount: amount,
      //       date: date,
      //       type: type,
      //       categoryName: categoryName,
      //       description: note,
      //       isBookmark: isBookmark,
      //       transactionImage: null,
      //     ).toJson();
      //     debugPrint('no pic..');
      //   } else {
      //     // late Uint8List thumbnailUint8List;
      //     // // decode the image
      //     // final fileAsImage = img.decodeImage(file.readAsBytesSync());
      //     // if (fileAsImage == null) {
      //     //   isLoading = false;
      //     //   // return false;
      //     //   throw const CouldNotBuildThumbnailException();
      //     // }

      //     // final thumbnail = img.copyResize(
      //     //   fileAsImage,
      //     //   height: ImageConstants.imageThumbnailHeight,
      //     // );
      //     // final thumbnailData = img.encodeJpg(thumbnail);
      //     // thumbnailUint8List = Uint8List.fromList(thumbnailData);

      //     // final thumbnailAspectRatio =
      //     //     await thumbnailUint8List.getAspectRatio();

      //     // final fileName = const Uuid().v4();

      //     // final thumbnailRef = FirebaseStorage.instance
      //     //     .ref()
      //     //     .child(userId)
      //     //     .child('transactions')
      //     //     .child(FirebaseCollectionName.thumbnails)
      //     //     .child(fileName);

      //     // final originalFileRef = FirebaseStorage.instance
      //     //     .ref()
      //     //     .child(userId)
      //     //     .child('transactions')
      //     //     .child('images')
      //     //     .child(fileName);

      //     // final thumbnailUploadTask =
      //     //     await thumbnailRef.putData(thumbnailUint8List);
      //     // final thumbnailStorageId = thumbnailUploadTask.ref.name;

      //     // final originalFileUploadTask = await originalFileRef.putFile(file);
      //     // final originalFileStorageId = originalFileUploadTask.ref.name;

      //     payload = Transaction(
      //       transactionId: transactionId,
      //       userId: userId,
      //       walletId: newWalletId,
      //       walletName: walletName,
      //       amount: amount,
      //       date: date,
      //       isBookmark: isBookmark,
      //       type: type,
      //       categoryName: categoryName,
      //       description: note,
      //       // thumbnailUrl: await thumbnailRef.getDownloadURL(),
      //       // fileUrl: await originalFileRef.getDownloadURL(),
      //       // fileName: fileName,
      //       // aspectRatio: thumbnailAspectRatio,
      //       // thumbnailStorageId: thumbnailStorageId,
      //       // originalFileStorageId: originalFileStorageId,
      //       // * failed to update transaction with image
      //       // transactionImage: TransactionImage(
      //       //   transactionId: transactionId,
      //       //   thumbnailUrl: await thumbnailRef.getDownloadURL(),
      //       //   fileUrl: await originalFileRef.getDownloadURL(),
      //       //   fileName: fileName,
      //       //   aspectRatio: thumbnailAspectRatio,
      //       //   thumbnailStorageId: thumbnailStorageId,
      //       //   originalFileStorageId: originalFileStorageId,
      //       // ),
      //     ).toJson();
      //   }
      //   debugPrint('uploading new transaction..');

      //   await FirebaseFirestore.instance
      //       .collection(FirebaseCollectionName.users)
      //       .doc(userId)
      //       .collection(FirebaseCollectionName.wallets)
      //       .doc(newWalletId)
      //       .collection(FirebaseCollectionName.transactions)
      //       .doc(transactionId)
      //       .set(payload);
      //   debugPrint('Transaction added $payload');
      // } else {
      // update the transaction in the same wallet
      await FirebaseFirestore.instance
          // .collection(FirebaseCollectionName.users)
          // .doc(userId)
          // .collection(FirebaseCollectionName.wallets)
          // .doc(originalWalletId)
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
      // }

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

// * toggle bookmark in UpdateTransaction
  Future<bool> toogleBookmark({
    required Transaction transaction,
  }) async {
    try {
      isLoading = true;

      final querySnaptshot = FirebaseFirestore.instance
          // .collection(FirebaseCollectionName.users)
          // .doc(transaction.userId)
          // .collection(FirebaseCollectionName.wallets)
          // .doc(transaction.walletId)
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

// * delete transaction
  Future<bool> deleteTransaction({
    required String transactionId,
    required UserId userId,
    required String walletId,
  }) async {
    try {
      isLoading = true;
      final querySnaptshot = FirebaseFirestore.instance
          // .collection(FirebaseCollectionName.users)
          // .doc(userId)
          // .collection(FirebaseCollectionName.wallets)
          // .doc(walletId)
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
