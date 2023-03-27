import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/data/user_wallets_provider.dart';
import 'package:pocketfi/src/features/timeline/bills/data/bill_notifiers.dart';
import 'package:pocketfi/src/features/timeline/bills/domain/bill.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';

// * bill provider for create, update, and delete bills
final billProvider =
    StateNotifierProvider<BillNotifier, IsLoading>((ref) => BillNotifier());

final selectedBillProvider = StateNotifierProvider<SelectedBillNotifier, Bill?>(
  (_) => SelectedBillNotifier(null),
);

// * get all bills from

// * get all bills from all wallets
final userBillsProvider = StreamProvider.autoDispose<Iterable<Bill>>(
  (ref) {
    final userId = ref.watch(userIdProvider);
    final walletId = ref.watch(selectedWalletProvider)?.walletId;
    debugPrint('walletId: $walletId');
    final controller = StreamController<Iterable<Bill>>();

    controller.onListen = () {
      controller.sink.add([]);
    };

    final sub = FirebaseFirestore.instance
        // .collection(FirebaseCollectionName.users)
        // .doc(userId)
        // .collection(FirebaseCollectionName.wallets)
        // .doc(walletId)
        // .collection(FirebaseCollectionName.bills)
        // .where(FirebaseFieldName.walletId, isEqualTo: walletId)
        .collectionGroup(FirebaseCollectionName.bills)
        .where(FirebaseFieldName.userId, isEqualTo: userId)
        .orderBy(BillKey.dueDate, descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        final documents = snapshot.docs;
        final bills = documents
            .where(
              (doc) => !doc.metadata.hasPendingWrites,
            )
            .map(
              (doc) => Bill.fromJson(
                billId: doc.id,
                json: doc.data(),
              ),
            );
        controller.sink.add(bills);
      },
    );
    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });
    return controller.stream;
  },
);
