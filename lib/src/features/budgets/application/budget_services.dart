import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/budgets/data/budget_repository.dart';
import 'package:pocketfi/src/features/budgets/domain/budget.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';

final budgetProvider = StateNotifierProvider<BudgetNotifier, IsLoading>(
  (ref) => BudgetNotifier(),
);

final selectedBudgetProvider =
    StateNotifierProvider<SelectedBudgetNotifier, Budget?>(
  (_) => SelectedBudgetNotifier(null),
);

class SelectedBudgetNotifier extends StateNotifier<Budget?> {
  SelectedBudgetNotifier(Budget? budget) : super(budget);

  void setSelectedBudget(Budget budget, WidgetRef ref) {
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
