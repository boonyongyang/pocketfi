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
  // ! only can display the first one. Need to fix
  // final sub = FirebaseFirestore.instance
  //     .collectionGroup(FirebaseCollectionName.budgets)
  //     .where(FirebaseFieldName.userId, isEqualTo: userId)
  //     .snapshots()
  //     .listen((snapshot) {
  //   final document = snapshot.docs;
  //   final budgets = document.map(
  //     (doc) => Budget.fromJson(doc.data()),
  //   );

  //   // Group the budgets by wallet ID
  //   final groupedBudgets = groupBy(budgets, (budget) => budget.walletId);

  //   // Take the first budget from each group
  //   final uniqueBudgets = groupedBudgets.values.expand((budgets) => budgets);
  //   // print(uniqueBudgets);s

  //   controller.sink.add(uniqueBudgets);
  //   // controller.sink.add(budgets);
  // });
  final sub = FirebaseFirestore.instance
      .collectionGroup(FirebaseCollectionName.budgets)
      .where(FirebaseFieldName.userId, isEqualTo: userId)
      .snapshots()
      .listen((snapshot) {
    final document = snapshot.docs;
    final budgets = document.map(
      (doc) => Budget.fromJson(doc.data()),
    );

    // loop through all budgets, if budget id is the same then don't add it to the list
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
          controller.sink.add(budgetsList);
        }
      }
    }
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

// final userBudgetsProvider = StreamProvider.autoDispose<Iterable<Budget>>((ref) {
//   final userId = ref.watch(userIdProvider);
//   final wallets = ref.watch(userWalletsProvider).value;
//   final controller = StreamController<Iterable<Budget>>();

//   // final subs = <StreamSubscription>[];

//   for (final wallet in wallets!) {
//     debugPrint('walletId: ${wallet.walletId}');
//     debugPrint('walletName: ${wallet.walletName}');
//     var sub = FirebaseFirestore.instance
//         .collection(FirebaseCollectionName.users)
//         .doc(userId)
//         .collection(FirebaseCollectionName.wallets)
//         .doc(wallet.walletId)
//         .collection(FirebaseCollectionName.budgets)
//         // .collectionGroup(FirebaseCollectionName.budgets)
//         .where(FirebaseFieldName.userId, isEqualTo: userId)
//         // .where(FirebaseFieldName.walletId, isEqualTo: wallet.walletId)
//         .snapshots()
//         .listen((snapshot) {
//       // debugPrint('Received snapshot: ${snapshot.docs.length} documents');
//       var documents = snapshot.docs;
//       var budgets = documents.map((doc) => Budget.fromJson(doc.data()));
//       controller.sink.add(budgets);
//     });
//     // subs.add(sub);
//   }
//   debugPrint('controller: ${controller.stream.length}');

//   ref.onDispose(() {
//     // for (final sub in subs) {
//     //   sub.cancel();
//     // }
//     controller.close();
//   });

//   return controller.stream;
// });
