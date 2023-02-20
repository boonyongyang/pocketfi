import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/auth/providers/user_id_provider.dart';
import 'package:pocketfi/state/constants/firebase_collection_name.dart';
import 'package:pocketfi/state/constants/firebase_field_name.dart';
import 'package:pocketfi/state/tabs/budget/wallet/models/wallet.dart';

final userWalletsProvider = StreamProvider.autoDispose<Iterable<Wallet>>((ref) {
  final userId = ref.watch(userIdProvider);
  final controller = StreamController<Iterable<Wallet>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.wallets)
      .where(FirebaseFieldName.userId, isEqualTo: userId)
      // .orderBy(FirebaseFieldName.createdAt,
      //     descending: true) //TODO: need to test
      .snapshots()
      .listen((snapshot) {
    final document = snapshot.docs;
    final wallets = document.where((doc) => !doc.metadata.hasPendingWrites).map(
          (doc) => Wallet(walletId: doc.id, doc.data()),
        );
    controller.sink.add(wallets);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
});
