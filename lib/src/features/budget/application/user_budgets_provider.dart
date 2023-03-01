import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_collection_name.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/budget/domain/budget.dart';

final userBudgetsProvider = StreamProvider.autoDispose<Iterable<Budget>>((ref) {
  final userId = ref.watch(userIdProvider);
  // !temporary only
  const walletId = '2023-03-01T12:02:23.282294';
  final controller = StreamController<Iterable<Budget>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.users)
      .doc(userId)
      .collection(FirebaseCollectionName.wallets)
      .doc(walletId)
      .collection(FirebaseCollectionName.budgets)
      .snapshots()
      .listen((snapshot) {
    final document = snapshot.docs;
    final budgets = document.map(
      (doc) => Budget(doc.data()),
    );

    controller.sink.add(budgets);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
});
