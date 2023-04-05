import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/wallets/application/wallet_services.dart';

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
        .collection(FirebaseCollectionName.transactions)
        // .where(TransactionKey.userId, isEqualTo: userId)
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
