import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_collection_name.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/budget/domain/budget.dart';

final totalAmountProvider = StreamProvider.autoDispose<double>((ref) {
  final userId = ref.watch(userIdProvider);
  // !temporary only
  const walletId = '2023-03-01T12:02:23.282294';
  final controller = StreamController<double>();

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
      (doc) => Budget(doc.data()).budgetAmount,
    );
    // get budgetAmount from all budgets code
    final totalBudgetAmount = budgets.fold(
      0.00,
      (previousValue, element) => previousValue + element,
    );

    controller.sink.add(totalBudgetAmount);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
});
