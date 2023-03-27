import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';

class UpdateSavingGoalNotifier extends StateNotifier<IsLoading> {
  UpdateSavingGoalNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> updateSavingGoal({
    required String savingGoalId,
    required String userId,
    required String walletId,
    required String savingGoalName,
    required double savingGoalAmount,
    required DateTime startDate,
    required DateTime dueDate,
  }) async {
    try {
      isLoading = true;

      final query = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(userId)
          .collection(FirebaseCollectionName.wallets)
          .doc(walletId)
          .collection(FirebaseCollectionName.savingGoals)
          .where(FirebaseFieldName.savingGoalId, isEqualTo: savingGoalId)
          .get();

      await query.then((query) async {
        for (final doc in query.docs) {
          if (savingGoalName != doc[FirebaseFieldName.savingGoalName] ||
              savingGoalAmount != doc[FirebaseFieldName.savingGoalAmount] ||
              startDate != doc[FirebaseFieldName.savingGoalStartDate] ||
              dueDate != doc[FirebaseFieldName.savingGoalDueDate]) {
            await doc.reference.update({
              FirebaseFieldName.savingGoalName: savingGoalName,
              FirebaseFieldName.savingGoalAmount: savingGoalAmount,
              FirebaseFieldName.savingGoalStartDate: startDate,
              FirebaseFieldName.savingGoalDueDate: dueDate,
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
}
