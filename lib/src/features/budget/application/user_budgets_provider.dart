import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/budget/domain/budget.dart';
import 'package:pocketfi/src/features/budget/wallet/data/user_wallets_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/data/wallet_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet.dart';

final userBudgetsProvider = StreamProvider.autoDispose<Iterable<Budget>>((ref) {
  final userId = ref.watch(userIdProvider);
  final wallets = ref.watch(userWalletsProvider).value;
  final controller = StreamController<Iterable<Budget>>();

  final sub = FirebaseFirestore.instance
      .collectionGroup(FirebaseCollectionName.budgets)
      .where(FirebaseFieldName.userId, isEqualTo: userId)
      .snapshots()
      .listen((snapshot) {
    final document = snapshot.docs;
    final budgets = document.map(
      (doc) => Budget.fromJson(doc.data()),
    );

    //! need to fix
    //! using iterable can solve the duplicate problem but it will only work
    //! if there are shared wallets
    //! if there are no shared wallets, then it will not work
    //! another issue is once it is in the budgetlist, when left 2 budget, it
    //! will not be removed from the view. but the database is updated
    // if all wallets are not shared wallets, then use controller.sink.add(budgets)
    // if all wallets are shared wallets, then use controller.sink.add(budgetsList)
    // if some wallets are shared wallets, then use controller.sink.add(budgetsList)

    // Check if any budgets have collaborators
    // bool hasCollaborators = false;
    // for (var budget in budgets) {
    //   if (ref
    //           .watch(getWalletFromWalletIdProvider(budget.walletId))
    //           .value
    //           ?.collaborators !=
    //       null) {
    //     hasCollaborators = true;
    //     break;
    //   }
    // }

    // If there are collaborators, add each unique budget to the list
    // if (hasCollaborators) {
    //   Iterable<Budget> budgetsList = [];

    //   for (var budget in budgets) {
    //     var isSame = false;
    //     for (var budgetList in budgetsList) {
    //       if (budget.budgetId == budgetList.budgetId) {
    //         isSame = true;
    //       }
    //     }
    //     if (!isSame) {
    //       budgetsList = [...budgetsList, budget];
    //     }
    //   }

    //   // if all wallets are shared wallets, then use controller.sink.add(budgetsList)
    //   if (budgets.length == budgetsList.length) {
    //     controller.sink.add(budgetsList);
    //   }
    //   // if some wallets are shared wallets, then use controller.sink.add(budgetsList)
    //   else {
    //     controller.sink.add(budgetsList);
    //   }
    // }
    // // if all wallets are not shared wallets, then use controller.sink.add(budgets)
    // else {
    //   controller.sink.add(budgets);
    // }
    // });
    // get wallet with wallet id
    // var wallet;
    // for (var budget in budgets) {
    //   var wallet =
    //       ref.watch(getWalletFromWalletIdProvider(budget.walletId)).value;
    //   debugPrint('walletName: ${wallet!.walletName}');
    //   debugPrint('walletId: ${wallet.walletId}');
    //   if (wallet.collaborators == null) {
    //     controller.sink.add(budgets);
    //   } else {
    //     // loop through all budgets, if budget id is the same then don't add it to the list
    //     Iterable<Budget> budgetsList = [];

    //     for (var budget in budgets) {
    //       if (budgetsList.isEmpty) {
    //         budgetsList = [budget];
    //       } else {
    //         var isSame = false;
    //         for (var budgetList in budgetsList) {
    //           if (budget.budgetId == budgetList.budgetId) {
    //             isSame = true;
    //           }
    //         }
    //         if (!isSame) {
    //           budgetsList = [...budgetsList, budget];
    //           controller.sink.add(budgetsList);
    //         }
    //       }
    //     }
    //   }
    // }

// how to determind the wallet is a shared wallet

    // loop through all budgets, if budget id is the same then don't add it to the list
    // Iterable<Budget> budgetsList = [];

    // for (var budget in budgets) {
    //   if (budgetsList.isEmpty) {
    //     budgetsList = [budget];
    //     debugPrint('budgetsList: ${budgetsList.length}');
    //   } else {
    //     var isSame = false;
    //     for (var budgetList in budgetsList) {
    //       if (budget.budgetId == budgetList.budgetId) {
    //         isSame = true;
    //         debugPrint('budgetsList: ${budgetsList.length}');
    //       }
    //     }
    //     if (!isSame) {
    //       budgetsList = [...budgetsList, budget];
    //       debugPrint('budgetsList: ${budgetsList.length}');
    //       controller.sink.add(budgetsList);
    //     }
    //   }
    // }
    controller.sink.add(budgets);
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

//   final sub = FirebaseFirestore.instance
//       .collectionGroup(FirebaseCollectionName.budgets)
//       .where(FirebaseFieldName.userId, isEqualTo: userId)
//       .snapshots()
//       .listen((snapshot) {
//     final document = snapshot.docs;
//     final budgets = document.map(
//       (doc) => Budget.fromJson(doc.data()),
//     );

//     // Check if any budgets have collaborators
//     bool hasCollaborators = false;
//     for (var budget in budgets) {
//       if (ref
//               .watch(getWalletFromWalletIdProvider(budget.walletId))
//               .value
//               ?.collaborators !=
//           null) {
//         hasCollaborators = true;
//         break;
//       }
//     }

//     // If there are collaborators, add each unique budget to the list
//     if (hasCollaborators) {
//       Iterable<Budget> budgetsList = [];

//       for (var budget in budgets) {
//         var isSame = false;
//         for (var budgetList in budgetsList) {
//           if (budget.budgetId == budgetList.budgetId) {
//             isSame = true;
//           }
//         }
//         if (!isSame) {
//           budgetsList = [...budgetsList, budget];
//         }
//       }
//       controller.sink.add(budgetsList);
//     } else {
//       // If there are no collaborators, add all budgets to the stream
//       controller.sink.add(budgets);
//     }
//   });

//   ref.onDispose(() {
//     sub.cancel();
//     controller.close();
//   });
//   return controller.stream;
// });
