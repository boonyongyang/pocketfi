//* Debts
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/finance/saving_goals/data/delete_saving_goal_notifier.dart';
import 'package:pocketfi/src/features/finance/saving_goals/data/update_saving_goal_notifier.dart';
import 'package:pocketfi/src/features/finance/saving_goals/domain/saving_goal.dart';

import '../data/create_new_saving_goal_notifier.dart';

final createSavingGoalProvider =
    StateNotifierProvider<CreateNewSavingGoalNotifier, IsLoading>(
  (ref) => CreateNewSavingGoalNotifier(),
);
final deleteSavingGoalProvider =
    StateNotifierProvider<DeleteSavingGoalNotifier, IsLoading>(
  (ref) => DeleteSavingGoalNotifier(),
);
final updateSavingGoalProvider =
    StateNotifierProvider<UpdateSavingGoalNotifier, IsLoading>(
  (ref) => UpdateSavingGoalNotifier(),
);

final userSavingGoalsProvider =
    StreamProvider.autoDispose<Iterable<SavingGoal>>((ref) {
  final userId = ref.watch(userIdProvider);
  final controller = StreamController<Iterable<SavingGoal>>();

  final sub = FirebaseFirestore.instance
      // .collection(FirebaseCollectionName.users)
      // .doc(userId)
      // .collection(FirebaseCollectionName.wallets)
      // .doc(walletId)
      .collectionGroup(FirebaseCollectionName.savingGoals)
      .where(FirebaseFieldName.userId, isEqualTo: userId)
      .snapshots()
      .listen((snapshot) {
    final document = snapshot.docs;
    final savingGoals = document
        // .where(
        //   (element) => element.data()[FirebaseFieldName.userId] == userId,
        // )
        .map((e) => SavingGoal.fromJson(e.data()))
        .toList();
    controller.add(savingGoals);
  });

  ref.onDispose(sub.cancel);
  return controller.stream;
});
