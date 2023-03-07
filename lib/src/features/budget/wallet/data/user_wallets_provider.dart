import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet.dart';

final selectedWalletProvider = StateProvider.autoDispose<Wallet?>(
  (ref) {
    final wallets = ref.watch(userWalletsProvider).value;
    if (wallets == null) {
      debugPrint('wallets is null');
      return null;
    }
    debugPrint('wallets is ${wallets.last.walletName}');

    // get the latest transaction to see which wallet was used, then return that wallet
    // check the transaction createdAt date to compare which is the newest transaction and belongs to which wallet collection,
    // then return that wallet
    // FIXME this is not the best way to do it, it should be done in the backend

    return wallets.last;
  },
);

final userWalletsProvider = StreamProvider.autoDispose<Iterable<Wallet>>((ref) {
  final userId = ref.watch(userIdProvider);
  final controller = StreamController<Iterable<Wallet>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.users)
      .doc(userId)
      .collection(FirebaseCollectionName.wallets)
      .where(FirebaseFieldName.userId, isEqualTo: userId)

      // .orderBy(FirebaseFieldName.createdAt,
      //     descending: true) //TODO: need to test
      .snapshots()
      .listen((snapshot) {
    final document = snapshot.docs;
    final wallets = document.map(
      (doc) => Wallet(doc.data()),
    );
    // .where((doc) => !doc.metadata.hasPendingWrites)
    controller.sink.add(wallets);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
});
