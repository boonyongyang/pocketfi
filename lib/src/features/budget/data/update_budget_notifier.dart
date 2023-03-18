import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/budget/domain/budget.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';

class UpdateBudgetNotifier extends StateNotifier<IsLoading> {
  UpdateBudgetNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> updateBudget({
    required String budgetId,
    required String budgetName,
    required double budgetAmount,
    required String walletId,
    required String? categoryName,
  }) async {
    try {
      isLoading = true;
      // change the budget name and the budet amount
      final query = FirebaseFirestore.instance
          .collectionGroup(FirebaseCollectionName.budgets)
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

      // change the wallet?
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}

final selectedBudgetProvider =
    StateNotifierProvider<SelectedBudgetNotifier, Budget?>(
  (_) => SelectedBudgetNotifier(null),
);

class SelectedBudgetNotifier extends StateNotifier<Budget?> {
  SelectedBudgetNotifier(Budget? budget) : super(budget);

  void setSelectedTransaction(Budget budget, WidgetRef ref) {
    // // if transaction is null, create a new transaction instance
    // state = Transaction.fromJson(
    //   transactionId: transaction.transactionId,
    //   json: transaction.toJson(),
    // );

    state = budget;
  }

  void updateCategory(Category newCategory, WidgetRef ref) {
    Budget? budget = ref.watch(selectedBudgetProvider);
    // debugPrint('budget: ${budget?.categoryName}');
    if (budget != null) {
      budget = budget.copyWith(categoryName: newCategory.name);
      // debugPrint('budget after: ${budget.categoryName}');
      state = budget;
    }
  }
}
