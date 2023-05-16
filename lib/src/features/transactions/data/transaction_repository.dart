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
import 'package:pocketfi/src/features/shared/date_picker/application/date_services.dart';
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
final userTransactionsProvider = StreamProvider<Iterable<Transaction>>(
  (ref) {
    final wallets = ref.watch(userWalletsProvider).value;
    final controller = StreamController<Iterable<Transaction>>();
    final subscriptions = <StreamSubscription>[];
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
      final updatedTransactionList = [
        ...transactions,
      ];
      controller.sink.add(updatedTransactionList);
    });
    subscriptions.add(sub);

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
final userTransactionsByMonthProvider = StreamProvider<Iterable<Transaction>>(
  (ref) {
    final wallets = ref.watch(userWalletsProvider).value;
    final month = ref.watch(overviewMonthProvider);
    final controller = StreamController<Iterable<Transaction>>();
    final subscriptions = <StreamSubscription>[];
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
      final updatedTransactionList = [
        ...transactions,
      ];
      controller.sink.add(updatedTransactionList);
    });
    subscriptions.add(sub);
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
    StreamProvider<Iterable<Transaction>>(
  (ref) {
    final wallets = ref.watch(userWalletsProvider).value!;
    final month = ref.watch(overviewMonthProvider);
    final walletVisibility = ref.watch(walletVisibilityProvider);
    final controller = StreamController<Iterable<Transaction>>();

    final subscriptions = <StreamSubscription>[];

    // get all transactions from all wallets
    final stream = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.transactions)
        .where(
          FirebaseFieldName.walletId,
          whereIn: wallets.map((wallet) => wallet.walletId).toList(),
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
            );
            // If the wallet is not found or its visibility is true, include the transaction
            return walletVisibility[wallet] == true;
          })
          .where((transaction) => transaction.date.month == month.month)
          // exclude transactions that are after today's date
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
    subscriptions.add(sub);
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
    String? merchant,
    String? note,
    bool isBookmark = false,
    List<String>? tags,
  }) async {
    isLoading = true;

    final transactionId = documentIdFromCurrentDate();
    final imageFile = File(imagePath);

    try {
      final Map<String, dynamic> payload;
      late Uint8List thumbnailUint8List;
      final fileAsImage = img.decodeImage(imageFile.readAsBytesSync());
      if (fileAsImage == null) {
        isLoading = false;
        throw const CouldNotBuildThumbnailException();
      }

      final thumbnail = img.copyResize(
        fileAsImage,
        height: ImageConstants.imageThumbnailHeight,
      );
      final thumbnailData = img.encodeJpg(thumbnail);
      thumbnailUint8List = Uint8List.fromList(thumbnailData);
      final thumbnailAspectRatio = await thumbnailUint8List.getAspectRatio();
      final fileName = const Uuid().v4();
      final thumbnailRef = FirebaseStorage.instance
          .ref()
          .child(userId)
          .child('transactions')
          .child(FirebaseCollectionName.thumbnails)
          .child(fileName);
      final originalFileRef = FirebaseStorage.instance
          .ref()
          .child(userId)
          .child('transactions')
          .child('images')
          .child(fileName);
      final thumbnailUploadTask =
          await thumbnailRef.putData(thumbnailUint8List);
      final thumbnailStorageId = thumbnailUploadTask.ref.name;
      final originalFileUploadTask = await originalFileRef.putFile(imageFile);
      final originalFileStorageId = originalFileUploadTask.ref.name;

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
        transactionImage: TransactionImage(
          transactionId: transactionId,
          thumbnailUrl: await thumbnailRef.getDownloadURL(),
          fileUrl: await originalFileRef.getDownloadURL(),
          fileName: fileName,
          aspectRatio: thumbnailAspectRatio,
          thumbnailStorageId: thumbnailStorageId,
          originalFileStorageId: originalFileStorageId,
        ),
        tags: tags ?? [],
      ).toJson();
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.transactions)
          .doc(transactionId)
          .set(payload);
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
    List<String>? tags,
  }) async {
    isLoading = true;
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
          tags: tags ?? [],
        ).toJson();
      } else {
        late Uint8List thumbnailUint8List;
        final fileAsImage = img.decodeImage(file.readAsBytesSync());
        if (fileAsImage == null) {
          isLoading = false;
          throw const CouldNotBuildThumbnailException();
        }
        final thumbnail = img.copyResize(
          fileAsImage,
          height: ImageConstants.imageThumbnailHeight,
        );
        final thumbnailData = img.encodeJpg(thumbnail);
        thumbnailUint8List = Uint8List.fromList(thumbnailData);
        final thumbnailAspectRatio = await thumbnailUint8List.getAspectRatio();
        final fileName = const Uuid().v4();
        final thumbnailRef = FirebaseStorage.instance
            .ref()
            .child(userId)
            .child('transactions')
            .child(FirebaseCollectionName.thumbnails)
            .child(fileName);
        final originalFileRef = FirebaseStorage.instance
            .ref()
            .child(userId)
            .child('transactions')
            .child('images')
            .child(fileName);
        final thumbnailUploadTask =
            await thumbnailRef.putData(thumbnailUint8List);
        final thumbnailStorageId = thumbnailUploadTask.ref.name;
        final originalFileUploadTask = await originalFileRef.putFile(file);
        final originalFileStorageId = originalFileUploadTask.ref.name;
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
          transactionImage: TransactionImage(
            transactionId: transactionId,
            thumbnailUrl: await thumbnailRef.getDownloadURL(),
            fileUrl: await originalFileRef.getDownloadURL(),
            fileName: fileName,
            aspectRatio: thumbnailAspectRatio,
            thumbnailStorageId: thumbnailStorageId,
            originalFileStorageId: originalFileStorageId,
          ),
          tags: tags ?? [],
        ).toJson();
      }
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.transactions)
          .doc(transactionId)
          .set(payload);
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
    List<String>? tags,
  }) async {
    try {
      isLoading = true;
      await FirebaseFirestore.instance
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
        TransactionKey.tags: tags,
      });
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
          .collection(FirebaseCollectionName.transactions)
          .where(FieldPath.documentId, isEqualTo: transactionId)
          .limit(1)
          .get();
      await querySnaptshot.then((querySnaptshot) async {
        final doc = querySnaptshot.docs.first;
        await doc.reference.delete();
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
