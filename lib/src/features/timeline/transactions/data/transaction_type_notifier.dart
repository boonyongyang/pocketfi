import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_collection_name.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/category/domain/default_categories.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction_payload.dart';

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
    String? note,
  }) async {
    isLoading = true;

    final payload = TransactionPayload(
      userId: userId,
      amount: amount,
      description: note,
      // ! this is the problem --> need to do like the PostSettings one or just use category id instead
      category: expenseCategories.first.name,
      type: type,
    );

    final walletId = FieldPath.documentId.toString();
    debugPrint('walletId: $walletId');

    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(userId)
          .collection(FirebaseCollectionName.wallets)
          //TODO: get wallet id docuemnt id
          .doc(walletId)
          .collection(FirebaseCollectionName.transactions)
          .add(payload);
      debugPrint('Transaction added');
      return true;
    } catch (e) {
      debugPrint('Error adding transaction: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }
}
