import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/budgets/domain/budget.dart';
import 'package:pocketfi/src/features/wallets/data/wallet_repository.dart';
import 'package:pocketfi/src/utils/document_id_from_current_date.dart';

// * get all budgets from all wallets
final userBudgetsProvider = StreamProvider.autoDispose<Iterable<Budget>>((ref) {
  final userId = ref.watch(userIdProvider);
  final wallets = ref.watch(userWalletsProvider).value;
  final controller = StreamController<Iterable<Budget>>();

  final sub = FirebaseFirestore.instance
      // .collectionGroup(FirebaseCollectionName.budgets)
      .collection(FirebaseCollectionName.budgets)
      .where(FirebaseFieldName.userId, isEqualTo: userId)
      .snapshots()
      .listen((snapshot) {
    final document = snapshot.docs;
    final budgets = document
        .where(
          (doc) => !doc.metadata.hasPendingWrites,
        )
        .map(
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

final totalAmountProvider = StreamProvider.autoDispose<double>((ref) {
  final userId = ref.watch(userIdProvider);
  // !temporary only
  // const walletId = '2023-03-01T12:02:23.282294';
  final controller = StreamController<double>();

  // final refs = FirebaseFirestore.instance
  //     .collection(FirebaseCollectionName.users)
  //     .doc(userId);
  // .where(FirebaseFieldName.userId, isEqualTo: userId)
  // .snapshots();
  final sub = FirebaseFirestore.instance
      // .collection(FirebaseCollectionName.users)
      // .doc(userId)
      // .collection(FirebaseCollectionName.wallets)
      // .doc(walletId)
      // .collection(FirebaseCollectionName.budgets)
      // .collectionGroup(FirebaseCollectionName.budgets)
      .collection(FirebaseCollectionName.budgets)
      .where(FirebaseFieldName.userId, isEqualTo: userId)
      .snapshots()
      .listen((snapshot) {
    final document = snapshot.docs;
    final budgets = document.map(
      (doc) => Budget.fromJson(doc.data()).budgetAmount,
    );
    //! need to fix
    // get budgetAmount from all budgets code
    // Iterable<Budget> budgetsList = [];

    // for (var budget in budgets) {
    //   if (budgetsList.isEmpty) {
    //     budgetsList = [budget];
    //   } else {
    //     var isSame = false;
    //     for (var budgetList in budgetsList) {
    //       if (budget.budgetId == budgetList.budgetId) {
    //         isSame = true;
    //       }
    //     }
    //     if (!isSame) {
    //       budgetsList = [...budgetsList, budget];
    //       final totalBudgetAmount = budgetsList
    //           .map((budget) => budget.budgetAmount)
    //           .reduce((value, element) => value + element);

    //       controller.sink.add(totalBudgetAmount);
    //       // controller.sink.add(budgetsList);
    //     }
    //   }
    // }
    var totalAmount =
        budgets.fold(0.00, (previousValue, element) => previousValue + element);
    controller.sink.add(totalAmount);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
});

class BudgetNotifier extends StateNotifier<IsLoading> {
  BudgetNotifier() : super(false);

  set isLoading(bool isLoading) => state = isLoading;

// * add new budget
  Future<bool> addNewBudget({
    required String budgetName,
    required double budgetAmount,
    required String walletId,
    required UserId userId,
    required String categoryName,
  }) async {
    isLoading = true;

    final budgetId = documentIdFromCurrentDate();

    final walletDoc = await FirebaseFirestore.instance
        // .collectionGroup(FirebaseCollectionName.wallets)
        .collection(FirebaseCollectionName.wallets)
        .where(FirebaseFieldName.walletId, isEqualTo: walletId)
        .get();

    final ownerId = walletDoc.docs.first.get(FirebaseFieldName.ownerId);

    final payload = Budget(
      budgetId: budgetId,
      budgetName: budgetName,
      budgetAmount: budgetAmount,
      usedAmount: 0.00,
      walletId: walletId,
      userId: userId,
      categoryName: categoryName,
      ownerId: ownerId != userId ? ownerId : userId,
    ).toJson();

    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.budgets)
          .doc(budgetId)
          .set(payload);

      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
    }
  }

// * update budget
  Future<bool> updateBudget({
    required String budgetId,
    required String budgetName,
    required double budgetAmount,
    required String walletId,
    required String? categoryName,
  }) async {
    try {
      isLoading = true;
      final query = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.budgets)
          .where(FirebaseFieldName.budgetId, isEqualTo: budgetId)
          .get();
      await query.then((query) async {
        for (final doc in query.docs) {
          if (budgetName != doc[FirebaseFieldName.budgetName] ||
              budgetAmount != doc[FirebaseFieldName.budgetAmount] ||
              categoryName != doc[FirebaseFieldName.categoryName]) {
            await doc.reference.update({
              FirebaseFieldName.budgetName: budgetName,
              FirebaseFieldName.budgetAmount: budgetAmount,
              FirebaseFieldName.categoryName: categoryName,
            });
          }
        }
      });
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }

// * delete budget
  Future<bool> deleteBudget({
    required String budgetId,
  }) async {
    try {
      isLoading = true;

      final query = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.budgets)
          .where(FirebaseFieldName.budgetId, isEqualTo: budgetId)
          .get();

      await query.then((query) async {
        for (final doc in query.docs) {
          await doc.reference.delete();
        }
      });
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
