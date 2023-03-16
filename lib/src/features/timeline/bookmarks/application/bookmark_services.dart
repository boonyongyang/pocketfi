import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/data/user_wallets_provider.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';

// * used to toggle the state of the bookmark button
class BookmarkNotifier extends StateNotifier<IsBookmark> {
  BookmarkNotifier() : super(false);

  void toggleBookmark() {
    state = !state;
  }

  void resetBookmarkState() {
    state = false;
  }
}

final isBookmarkProvider = StateNotifierProvider<BookmarkNotifier, IsBookmark>(
    (ref) => BookmarkNotifier());

final bookmarkTransactionsProvider =
    StreamProvider.autoDispose<Iterable<Transaction>>(
  (ref) {
    final userId = ref.watch(userIdProvider);

    // FIXME get the selected walletId, need to based on Wallet Visibility
    // walletVisibilityProvider get boolean value for each wallet

    final walletId = ref.watch(selectedWalletProvider)?.walletId;

    final controller = StreamController<Iterable<Transaction>>();

    controller.onListen = () {
      controller.sink.add([]);
    };

    debugPrint(userId);

    final sub = FirebaseFirestore.instance
        // .collection(FirebaseCollectionName.users)
        // .doc(userId)
        // .collection(FirebaseCollectionName.wallets)
        // .doc(walletId)
        // .collection(FirebaseCollectionName.transactions)
        .collectionGroup(FirebaseCollectionName.transactions)
        .where(TransactionKey.userId, isEqualTo: userId)
        .where(TransactionKey.isBookmark, isEqualTo: true)
        .orderBy(FirebaseFieldName.date, descending: true)
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


// * contains a list of bookmarked transactions
// class BookmarkTransactionListNotifier extends StateNotifier<List<Transaction>> {
//   BookmarkTransactionListNotifier() : super([]);

// void addBookmark(Transaction transaction) {
//   state = [...state, transaction];
// }

// void removeBookmark(Transaction transaction) {
//   state = state
//       .where((element) => element.transactionId != transaction.transactionId)
//       .toList();
// }

// void toggleTransaction(Transaction transaction) {
//   if (state.contains(transaction)) {
//     removeTransaction(transaction);
//   } else {
//     addTransaction(transaction);
//   }
// }

// void clear() {
//   state = [];
// }
// }

// final bookmarkTransactionListProvider =
//     StateNotifierProvider<BookmarkTransactionListNotifier, List<Transaction>>(
//         (ref) => BookmarkTransactionListNotifier());
