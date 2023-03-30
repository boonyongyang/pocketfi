import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/saving_goals/domain/saving_goal.dart';
import 'package:pocketfi/src/utils/document_id_from_current_date.dart';

final userSavingGoalsProvider =
    StreamProvider.autoDispose<Iterable<SavingGoal>>((ref) {
  final userId = ref.watch(userIdProvider);
  final controller = StreamController<Iterable<SavingGoal>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.savingGoals)
      .where(FirebaseFieldName.userId, isEqualTo: userId)
      .snapshots()
      .listen((snapshot) {
    final document = snapshot.docs;
    final savingGoals = document
        .where(
          //   (element) => element.data()[FirebaseFieldName.userId] == userId,
          (doc) => !doc.metadata.hasPendingWrites,
        )
        .map((e) => SavingGoal.fromJson(e.data()))
        .toList();
    controller.add(savingGoals);
  });

  ref.onDispose(sub.cancel);
  return controller.stream;
});

class SavingGoalNotifier extends StateNotifier<IsLoading> {
  SavingGoalNotifier() : super(false);

  set isLoading(bool isLoading) => state = isLoading;

  // final SavingGoalRepository _savingGoalRepository;

  Future<bool> addNewSavingGoal({
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
        .collection(FirebaseCollectionName.savingGoals)
        .doc(savingGoalId)
        .set(payload);

    isLoading = false;
    return true;
  }

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

  Future<bool> deleteSavingGoal({
    required String savingGoalId,
    required String walletId,
    required UserId userId,
  }) async {
    isLoading = true;

    await FirebaseFirestore.instance
        .collection(FirebaseCollectionName.savingGoals)
        .doc(savingGoalId)
        .delete();

    isLoading = false;
    return true;
  }
}