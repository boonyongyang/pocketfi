import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_collection_name.dart';
import 'package:pocketfi/src/constants/firebase_field_name.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/data/user_wallets_provider.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/timeline/transactions/data/transaction_type_notifier.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction_key.dart';

final transactionTypeProvider =
    StateNotifierProvider<TransactionTypeNotifier, TransactionType>(
        (ref) => TransactionTypeNotifier());

final createNewTransactionProvider =
    StateNotifierProvider<CreateNewTransactionNotifier, IsLoading>(
        (ref) => CreateNewTransactionNotifier());

final userTransactionsProvider =
    StreamProvider.autoDispose<Iterable<Transaction>>(
  (ref) {
    final userId = ref.watch(userIdProvider);

    // FIXME get the selected walletId, need to based on Wallet Visibility
    // walletVisibilityProvider get boolean value for each wallet
// also need to use collectionGroup I think

    final walletId = ref.watch(selectedWalletProvider)?.walletId;

    final controller = StreamController<Iterable<Transaction>>();

    // The onListen callback is called when the stream is listened to.
    controller.onListen = () {
      // add an empty iterable to the stream.
      controller.sink.add([]);
    };

    debugPrint(userId);

    // subscribe to the transactions collection.
    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.users)
        .doc(userId)
        .collection(FirebaseCollectionName.wallets)
        // .doc('2023-02-27T23:18:16.426104')
        .doc(walletId)
        .collection(FirebaseCollectionName.transactions)
        .orderBy(
          FirebaseFieldName.date,
          descending: true, // descending order.
        )
        // .where(
        //   TransactionKey.userId,
        //   isEqualTo: userId,
        // )
        .snapshots()
        .listen(
      (snapshot) {
        final documents = snapshot.docs;
        final transactions = documents
            .where(
              (doc) => !doc.metadata.hasPendingWrites,
            )
            .map(
              (doc) => Transaction(
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
