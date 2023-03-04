import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/budget/data/delete_budget_notifier.dart';

final deleteBudgetProvider =
    StateNotifierProvider<DeleteBudgetStateNotifier, IsLoading>(
  (ref) => DeleteBudgetStateNotifier(),
);
