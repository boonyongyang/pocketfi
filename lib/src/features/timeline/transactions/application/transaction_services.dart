import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/data/user_wallets_provider.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/timeline/transactions/data/transaction_notifiers.dart';

final transactionTypeProvider =
    StateNotifierProvider<TransactionTypeNotifier, TransactionType>(
        (ref) => TransactionTypeNotifier());

final selectedTransactionProvider =
    StateNotifierProvider<SelectedTransactionNotifier, Transaction?>(
  (_) => SelectedTransactionNotifier(null),
);

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, IsLoading>(
        (ref) => TransactionNotifier());

// final transactionProvider =
//     StateNotifierProvider<TransactionNotifier, IsLoading>(
//         (ref) => TransactionNotifier());

// final transactionProvider =
//     StateNotifierProvider<TransactionNotifier, IsLoading>(
//         (ref) => TransactionNotifier());

// * get all transactions from all wallets
final userTransactionsProvider =
    StreamProvider.autoDispose<Iterable<Transaction>>(
  (ref) {
    final userId = ref.watch(userIdProvider);

    final walletId = ref.watch(selectedWalletProvider)?.walletId;

    final controller = StreamController<Iterable<Transaction>>();

    controller.onListen = () {
      controller.sink.add([]);
    };

    debugPrint(userId);

    final sub = FirebaseFirestore.instance
        .collectionGroup(FirebaseCollectionName.transactions)
        .where(TransactionKey.userId, isEqualTo: userId) // * not needed anymore
        // .where(FirebaseFieldName.walletId, isEqualTo: walletId)
        // .orderBy(FirebaseFieldName.walletId)
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

// final userTransactionsProvider =
//     StreamProvider.autoDispose<Iterable<Transaction>>(
//   (ref) async* {
//     final userId = ref.watch(userIdProvider);

//     // Fetch user's wallets
//     final walletsSnapshot = await FirebaseFirestore.instance
//         .collection(FirebaseCollectionName.users)
//         .doc(userId)
//         .collection(FirebaseCollectionName.wallets)
//         .get();
//     final walletIds = walletsSnapshot.docs.map((doc) => doc.id)
//         // .toList()
//         ;

//     debugPrint(walletIds.toString());

//     final controller = StreamController<Iterable<Transaction>>();

//     controller.onListen = () {
//       controller.sink.add([]);
//     };

//     debugPrint(userId);

//     // Create separate subscriptions for each wallet
//     final transactionsByWallet = <String, Iterable<Transaction>>{};
//     final allTransactions = <Transaction>{};

//     final subscriptions = walletIds.map((walletId) {
//       return FirebaseFirestore.instance
//           .collectionGroup(FirebaseCollectionName.transactions)
//           .where(FirebaseFieldName.walletId, isEqualTo: walletId)
//           .orderBy(TransactionKey.date, descending: true)
//           .snapshots()
//           .listen(
//         (snapshot) {
//           final documents = snapshot.docs;
//           final transactions = documents
//                   .where(
//                     (doc) => !doc.metadata.hasPendingWrites,
//                   )
//                   .map(
//                     (doc) => Transaction.fromJson(
//                       transactionId: doc.id,
//                       json: doc.data(),
//                     ),
//                   )
//               // .toList()
//               ;

//           transactionsByWallet[walletId] = transactions;

//           // Merge transactions from all wallets
//           allTransactions.clear();
//           for (var txs in transactionsByWallet.values) {
//             allTransactions.addAll(txs);
//           }
//           final updatedTransactions = allTransactions.toList();
//           updatedTransactions.sort((a, b) =>
//               b.date.compareTo(a.date)); // Sort by date in descending order

//           controller.sink.add(updatedTransactions);
//         },
//       );
//     })
//         // .toList()
//         ;

//     ref.onDispose(() {
//       for (var sub in subscriptions) {
//         sub.cancel();
//       }
//       controller.close();
//     });

//     yield* controller.stream;
//   },
// );



// * get all transactions from [SELECTED Wallet] only
// .collection(FirebaseCollectionName.users)
// .doc(userId)
// .collection(FirebaseCollectionName.wallets)
// .doc(walletId)
// .collection(FirebaseCollectionName.transactions)
// .orderBy(
//   FirebaseFieldName.date,
//   descending: true,
// )
