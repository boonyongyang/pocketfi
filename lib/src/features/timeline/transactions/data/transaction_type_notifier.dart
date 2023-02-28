import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_collection_name.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction_payload.dart';
import 'package:pocketfi/src/utils/document_id_from_current_date.dart';

class TransactionTypeNotifier extends StateNotifier<TransactionType> {
  TransactionTypeNotifier() : super(TransactionType.expense);

  void setTransactionType(int index) {
    state = TransactionType.values[index];
  }
}

class CreateNewTransactionNotifier extends StateNotifier<IsLoading> {
  CreateNewTransactionNotifier() : super(false);

  set isLoading(bool isLoading) => state = isLoading;

  Future<bool> createNewTransaction({
    required UserId userId,
    required double amount,
    required TransactionType type,
    required String categoryName,
    required DateTime date,
    String? note,
  }) async {
    isLoading = true;

    // FIXME temp solution to get the *first* wallet id
    final walletId = await FirebaseFirestore.instance
        .collection(FirebaseCollectionName.users)
        .doc(userId)
        .collection(FirebaseCollectionName.wallets)
        .limit(1)
        .get()
        .then((value) => value.docs.first.id);

    final transactionId = documentIdFromCurrentDate();

    final payload = TransactionPayload(
      userId: userId,
      amount: amount,
      description: note,
      categoryName: categoryName,
      type: type,
      date: date,
    );

    try {
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
