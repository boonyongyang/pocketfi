import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';

class UpdateBudgetNotifier extends StateNotifier<IsLoading> {
  UpdateBudgetNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> updateBudget({
    required String budgetId,
    required String budgetName,
    required double budgetAmount,
    required String walletId,
  }) async {
    try {
      isLoading = true;
      // change the budget name and the budet amount
      final query = FirebaseFirestore.instance
          .collectionGroup('budgets')
          .where(FirebaseFieldName.budgetId, isEqualTo: budgetId)
          .get();
      await query.then((query) async {
        for (final doc in query.docs) {
          if (budgetName != doc[FirebaseFieldName.budgetName] ||
              budgetAmount != doc[FirebaseFieldName.budgetAmount]) {
            await doc.reference.update({
              FirebaseFieldName.budgetName: budgetName,
              FirebaseFieldName.budgetAmount: budgetAmount,
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
