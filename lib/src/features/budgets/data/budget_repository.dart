import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/budgets/domain/budget.dart';
import 'package:pocketfi/src/features/wallets/data/wallet_repository.dart';
import 'package:pocketfi/src/utils/document_id_from_current_date.dart';

// * get all budgets from all wallets

final userBudgetsProvider = StreamProvider.autoDispose<Iterable<Budget>>((ref) {
  final wallets =
      ref.watch(userWalletsProvider).value; // use empty list if wallets is null
  final controller = StreamController<Iterable<Budget>>();

  // final budgetsList = <Budget>[]; // accumulate all budgets in a list
  final subscriptions = <StreamSubscription>[]; // store all subscriptions

  // go through wallet and check which wallet the user is a collaborator
  // for (var wallet in wallets!) {
  // debugPrint('wallet: ${wallet.walletName}');
  // debugPrint('walletId: ${wallet.walletId}');
  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.budgets)
      .where(
        FirebaseFieldName.walletId,
        whereIn: wallets!.map((wallet) => wallet.walletId).toList(),
      )
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

    final updatedDebtList = [...budgets];

    // budgetsList.addAll(budgets); // add budgets to the accumulated list
    // debugPrint('budgetsList: $budgetsList');
    // debugPrint('budgetsList length: ${budgetsList.length}');
    controller.sink.add(updatedDebtList);
  });
  // }

  subscriptions.add(sub); // add the subscription to the list
  ref.onDispose(() {
    for (var sub in subscriptions) {
      sub.cancel();
    }
    controller.close();
  });
  return controller.stream;
});

final totalAmountProvider = StreamProvider.autoDispose<double>((ref) {
  final userId = ref.watch(userIdProvider);
  final wallets = ref.watch(userWalletsProvider).value;
  final controller = StreamController<double>();

  final budgetsList = <double>[]; // accumulate all budgets in a list
  final subscriptions = <StreamSubscription>[];

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.budgets)
      .where(
        FirebaseFieldName.walletId,
        whereIn: wallets!.map((wallet) => wallet.walletId).toList(),
      )
      .snapshots()
      .listen((snapshot) {
    final document = snapshot.docs;
    final budgets = document
        .where(
          (doc) => !doc.metadata.hasPendingWrites,
        )
        .map(
          (doc) => Budget.fromJson(doc.data()).budgetAmount,
        );
    budgetsList.addAll(budgets);

    var totalAmount = budgetsList.fold(
        0.00, (previousValue, element) => previousValue + element);
    debugPrint('totalAmount: $totalAmount');
    controller.sink.add(totalAmount);
  });

  subscriptions.add(sub); // add the subscription to the list
  ref.onDispose(() {
    for (var sub in subscriptions) {
      sub.cancel();
    }
    controller.close();
  });
  return controller.stream;
});

Future<double> totalAmount() async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  // final budgetsList = <double>[]; // accumulate all budgets in a list
  var updatedDebtList = <double>[];

  final wallets = await FirebaseFirestore.instance
      .collection(FirebaseCollectionName.wallets)
      .where(FirebaseFieldName.userId, isEqualTo: userId)
      .get();

  for (var wallet in wallets.docs) {
    final budgets = await FirebaseFirestore.instance
        .collection(FirebaseCollectionName.budgets)
        .where(FirebaseFieldName.walletId, isEqualTo: wallet.id)
        .get();
    final budgetsAmount = budgets.docs
        .where(
          (doc) => !doc.metadata.hasPendingWrites,
        )
        .map(
          (doc) => Budget.fromJson(doc.data()).budgetAmount,
        );
    updatedDebtList = [...budgetsAmount, ...updatedDebtList];
    // for (var i in updatedDebtList) {
    //   debugPrint('updatedDebtList: $i');
    // }
    // debugPrint('updatedDebtList length: ${updatedDebtList.length}');
  }

  var totalAmount = updatedDebtList.fold(0.00, (previousValue, element) {
    // debugPrint('previousValue: $previousValue');
    // debugPrint('element: $element');
    return previousValue + element;
  });
  // debugPrint('totalAmount: $totalAmount');
  return totalAmount;
}

Future<double> usedAmount() async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  // final budgetsList = <double>[]; // accumulate all budgets in a list
  var updatedDebtList = <double>[];

  final wallets = await FirebaseFirestore.instance
      .collection(FirebaseCollectionName.wallets)
      .where(FirebaseFieldName.userId, isEqualTo: userId)
      .get();

  for (var wallet in wallets.docs) {
    final budgets = await FirebaseFirestore.instance
        .collection(FirebaseCollectionName.budgets)
        .where(FirebaseFieldName.walletId, isEqualTo: wallet.id)
        .get();
    final usedAmount = budgets.docs
        .where(
          (doc) => !doc.metadata.hasPendingWrites,
        )
        .map(
          (doc) => Budget.fromJson(doc.data()).usedAmount,
        );
    updatedDebtList = [...usedAmount, ...updatedDebtList];
  }

  var usedAmount = updatedDebtList.fold(
      0.00, (previousValue, element) => previousValue + element);
  // debugPrint('usedAmount: $usedAmount');
  return usedAmount;
}

Future<double> remainingAmount() async {
  return await totalAmount() - await usedAmount();
}

Future<double> spentPercentage() async {
  //* spent percentage
  if (await totalAmount() == 0.00) {
    // debugPrint('if');

    return 0.00;
  } else {
    // debugPrint('else');
    return await usedAmount() / await totalAmount();
  }
}

final usedAmountProvider = StreamProvider.autoDispose<double>((ref) {
  final wallets = ref.watch(userWalletsProvider).value;
  final controller = StreamController<double>();

  final budgetsList = <double>[]; // accumulate all budgets in a list
  final subscriptions = <StreamSubscription>[]; // store all subscriptions

  // for (var wallet in wallets!) {
  //   debugPrint('wallet: ${wallet.walletName}');
  //   debugPrint('walletId: ${wallet.walletId}');
  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.budgets)
      // .where(FirebaseFieldName.walletId, isEqualTo: wallet.walletId)
      .where(
        FirebaseFieldName.walletId,
        whereIn: wallets!.map((wallet) => wallet.walletId).toList(),
      )
      .snapshots()
      .listen((snapshot) {
    final document = snapshot.docs;
    final budgets = document
        .where(
          (doc) => !doc.metadata.hasPendingWrites,
        )
        .map(
          (doc) => Budget.fromJson(doc.data()).usedAmount,
        );
    budgetsList.addAll(budgets);

    var usedAmount = budgetsList.fold(
        0.00, (previousValue, element) => previousValue + element);
    // debugPrint('usedAmount: $usedAmount');
    controller.sink.add(usedAmount);
  });
  // }

  subscriptions.add(sub); // add the subscription to the list
  ref.onDispose(() {
    for (var sub in subscriptions) {
      sub.cancel();
    }
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

  Future<void> updateUsedAmount({
    required String budgetId,
    required double usedAmount,
  }) async {
    final query = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.budgets)
        .where(FirebaseFieldName.budgetId, isEqualTo: budgetId)
        .get();
    await query.then((query) async {
      for (final doc in query.docs) {
        if (usedAmount != doc[FirebaseFieldName.usedAmount]) {
          await doc.reference.update({
            FirebaseFieldName.usedAmount: usedAmount,
          });
        }
      }
    });
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
