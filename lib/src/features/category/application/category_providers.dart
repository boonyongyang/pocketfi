import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/category/constants.dart';
import 'package:pocketfi/src/features/category/data/category_state_notifier.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/timeline/transactions/application/transaction_provider.dart';

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
