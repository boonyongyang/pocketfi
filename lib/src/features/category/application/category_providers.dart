import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/category/domain/default_categories.dart';
import 'package:pocketfi/src/features/category/data/category_state_notifier.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/timeline/transactions/application/transaction_provider.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';

// * provide the first category based on the transaction type selected
final selectedCategoryProvider = StateProvider<Category>(
  (ref) {
    final transactionTypeIndex = ref.watch(transactionTypeProvider);
    if (transactionTypeIndex == TransactionType.expense) {
      return expenseCategories.first;
    } else if (transactionTypeIndex == TransactionType.income) {
      return incomeCategories.first;
    } else {
      return transferCategory;
      // return null;
    }
  },
);

void resetCategoryState(WidgetRef ref) {
  ref.read(selectedCategoryProvider.notifier).state = expenseCategories.first;
}

Category getCategoryWithCategoryName(String categoryName) {
  return expenseCategories.firstWhere(
    (category) => category.name == categoryName,
    orElse: () => incomeCategories.firstWhere(
      (category) => category.name == categoryName,
      orElse: () => transferCategory,
    ),
  );
}

// * provide the appropriate category list based on the transaction type
final categoriesProvider =
    StateNotifierProvider<CategoryNotifier, List<Category>>(
  (_) => CategoryNotifier(),
);

// * provide a list of expense categories
final expenseCategoriesProvider = Provider<List<Category>>(
  (ref) => expenseCategories,
);

// * provide a list of income categories
final incomeCategoriesProvider = Provider<List<Category>>(
  (ref) => incomeCategories,
);
