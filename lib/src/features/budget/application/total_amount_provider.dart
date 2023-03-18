import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/budget/domain/budget.dart';

final totalAmountProvider = StreamProvider.autoDispose<double>((ref) {
  final userId = ref.watch(userIdProvider);
  // !temporary only
  const walletId = '2023-03-01T12:02:23.282294';
  final controller = StreamController<double>();

  final refs = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.users)
      .doc(userId);
  // .where(FirebaseFieldName.userId, isEqualTo: userId)
  // .snapshots();
  final sub = FirebaseFirestore.instance
      // .collection(FirebaseCollectionName.users)
      // .doc(userId)
      // .collection(FirebaseCollectionName.wallets)
      // .doc(walletId)
      // .collection(FirebaseCollectionName.budgets)
      .collectionGroup(FirebaseCollectionName.budgets)
      .where(FirebaseFieldName.userId, isEqualTo: userId)
      .snapshots()
      .listen((snapshot) {
    final document = snapshot.docs;
    final budgets = document.map(
      (doc) => Budget.fromJson(doc.data()),
    );
    // get budgetAmount from all budgets code
    Iterable<Budget> budgetsList = [];

    for (var budget in budgets) {
      if (budgetsList.isEmpty) {
        budgetsList = [budget];
      } else {
        var isSame = false;
        for (var budgetList in budgetsList) {
          if (budget.budgetId == budgetList.budgetId) {
            isSame = true;
          }
        }
        if (!isSame) {
          budgetsList = [...budgetsList, budget];
          final totalBudgetAmount = budgetsList
              .map((budget) => budget.budgetAmount)
              .reduce((value, element) => value + element);

          controller.sink.add(totalBudgetAmount);
          // controller.sink.add(budgetsList);
        }
      }
    }
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
});
