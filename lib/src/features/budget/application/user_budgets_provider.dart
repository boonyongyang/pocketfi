import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/budget/domain/budget.dart';
import 'package:pocketfi/src/features/budget/wallet/data/user_wallets_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet.dart';

final userBudgetsProvider = StreamProvider.autoDispose<Iterable<Budget>>((ref) {
  final userId = ref.watch(userIdProvider);
  final wallets = ref.watch(userWalletsProvider).value;
  final controller = StreamController<Iterable<Budget>>();

  // var sub;

//create an async loop to get all the budgets code
  // wallets?.forEach((wallet) {
  //   var walletId = wallet.walletId;
  //   getBudgets(walletId).then((budgets) {
  //     controller.sink.add(budgets);
  //     for (var element in budgets) {
  //       debugPrint(element.budgetName);
  //     }
  //   });
  //   // Future.delayed(const Duration(seconds: 400));
  //   debugPrint(wallet.walletName);
  //   debugPrint(wallet.walletId);
  // });

  // }
  final sub = FirebaseFirestore.instance
      .collectionGroup(FirebaseCollectionName.budgets)
      .where(FirebaseFieldName.userId, isEqualTo: userId)
      .snapshots()
      .listen((snapshot) {
    final document = snapshot.docs;
    final budgets = document.map(
      (doc) => Budget(doc.data()),
    );

// Group the budgets by wallet ID
    final groupedBudgets = groupBy(budgets, (budget) => budget.walletId);

    // Take the first budget from each group
    final uniqueBudgets = groupedBudgets.values.map((budgets) => budgets.first);

    controller.sink.add(uniqueBudgets);
    // controller.sink.add(budgets);
  });

  // final sub = FirebaseFirestore.instance
  //     .collection(FirebaseCollectionName.users)
  //     .doc(userId)
  //     .collection(FirebaseCollectionName.wallets)
  //     .doc(wallets!.first.walletId)
  //     .collection(FirebaseCollectionName.budgets)
  //     .snapshots()
  //     .listen((snapshot) {
  //   final document = snapshot.docs;
  //   final budgets = document.map(
  //     (doc) => Budget(doc.data()),
  //   );

  //   controller.sink.add(budgets);
  // });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
});
