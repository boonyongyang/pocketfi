//* Debts
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/saving_goals/data/saving_goal_repository.dart';
import 'package:pocketfi/src/features/saving_goals/domain/saving_goal.dart';

final savingGoalProvider = StateNotifierProvider<SavingGoalNotifier, IsLoading>(
  (ref) => SavingGoalNotifier(),
);

// selected Saving goal
final selectedSavingGoalProvider =
    StateNotifierProvider<SelectedSavingGoalNotifier, SavingGoal?>(
  (_) => SelectedSavingGoalNotifier(null),
);

class SelectedSavingGoalNotifier extends StateNotifier<SavingGoal?> {
  SelectedSavingGoalNotifier(SavingGoal? savingGoal) : super(savingGoal);

  void setSelectedSavingGoal(SavingGoal savingGoal, WidgetRef ref) {
    state = savingGoal;
  }
}
