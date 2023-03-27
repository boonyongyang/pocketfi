import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';

class DeleteSavingGoalNotifier extends StateNotifier<IsLoading> {
  DeleteSavingGoalNotifier() : super(false);

  set isLoading(bool isLoading) => state = isLoading;

  Future<bool> deleteSavingGoal({
    required String savingGoalId,
    required String walletId,
    required UserId userId,
  }) async {
    isLoading = true;

    await FirebaseFirestore.instance
        .collection(FirebaseCollectionName.users)
        .doc(userId)
        .collection(FirebaseCollectionName.wallets)
        .doc(walletId)
        .collection(FirebaseCollectionName.savingGoals)
        .doc(savingGoalId)
        .delete();

    isLoading = false;
    return true;
  }
}
