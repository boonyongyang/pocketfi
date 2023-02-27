import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/budget/data/create_new_budget_notifier.dart';
import 'package:pocketfi/src/constants/typedefs.dart';

final createNewBudgetProvider =
    StateNotifierProvider<CreateNewBudgetNotifier, IsLoading>(
  (ref) => CreateNewBudgetNotifier(),
);
