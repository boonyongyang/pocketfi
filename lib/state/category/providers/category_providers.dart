import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/category/constants/constants.dart';
import 'package:pocketfi/state/category/models/category.dart';
import 'package:pocketfi/state/category/notifiers/category_state_notifier.dart';
import 'package:pocketfi/state/tabs/timeline/transaction/providers/transaction_provider.dart';

final selectedCategoryProvider = StateProvider<Category?>(
  (ref) {
    final transactionTypeIndex = ref.watch(transactionTypeProvider);

    if (transactionTypeIndex == 0) {
      return expenseCategories.first;
    } else if (transactionTypeIndex == 1) {
      return incomeCategories.first;
    } else {
      return null;
    }
  },
);

final categoriesProvider =
    StateNotifierProvider<CategoryNotifier, List<Category>>(
  (_) => CategoryNotifier(),
);

final expenseCategoriesProvider = Provider<List<Category>>(
  (ref) => expenseCategories,
);

final incomeCategoriesProvider = Provider<List<Category>>(
  (ref) => incomeCategories,
);
