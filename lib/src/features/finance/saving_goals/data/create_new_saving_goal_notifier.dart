import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/finance/saving_goals/domain/saving_goal.dart';
import 'package:pocketfi/src/utils/document_id_from_current_date.dart';

class CreateNewSavingGoalNotifier extends StateNotifier<IsLoading> {
  CreateNewSavingGoalNotifier() : super(false);

  set isLoading(bool isLoading) => state = isLoading;

  // final SavingGoalRepository _savingGoalRepository;

  Future<bool> createNewSavingGoal({
    required String savingGoalName,
    required double savingGoalAmount,
    required String walletId,
    required UserId userId,
    required DateTime startDate,
    required DateTime dueDate,
  }) async {
    isLoading = true;

    final savingGoalId = documentIdFromCurrentDate();

    final payload = SavingGoal(
      savingGoalId: savingGoalId,
      savingGoalName: savingGoalName,
      savingGoalAmount: savingGoalAmount,
      walletId: walletId,
      userId: userId,
      startDate: startDate,
      dueDate: dueDate,
    ).toJson();

    await FirebaseFirestore.instance
        .collection(FirebaseCollectionName.users)
        .doc(userId)
        .collection(FirebaseCollectionName.wallets)
        .doc(walletId)
        .collection(FirebaseCollectionName.savingGoals)
        .doc(savingGoalId)
        .set(payload);

    isLoading = false;
    return true;
  }
}
