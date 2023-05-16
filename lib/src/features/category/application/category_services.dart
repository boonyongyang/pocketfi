import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/category/data/category_repository.dart';
import 'package:flutter/material.dart' show Color, Colors, IconData;
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/transactions/application/transaction_services.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';

// * provide the first category based on the transaction type selected
final selectedCategoryProvider = StateProvider<Category>(
  (ref) {
    final type = ref.watch(transactionTypeProvider);
    if (type == TransactionType.expense) {
      return expenseCategories.first;
    } else if (type == TransactionType.income) {
      return incomeCategories.first;
    } else {
      return transferCategory;
    }
  },
);

void resetCategoryState(WidgetRef ref) {
  ref.read(selectedCategoryProvider.notifier).state = expenseCategories.first;
}

void setBillCategory(WidgetRef ref) {
  ref.read(selectedCategoryProvider.notifier).state = expenseCategories
      .where((element) => element.name == 'Bills and Fees')
      .first;
}

Category getCategoryWithCategoryName(String? categoryName) {
  return expenseCategories.firstWhere(
    (category) => category.name == categoryName,
    orElse: () => incomeCategories.firstWhere(
      (category) => category.name == categoryName,
      orElse: () => transferCategory,
    ),
  );
}

// * to get the type of the category
TransactionType getCategoryType(Category category) {
  if (expenseCategories.contains(category)) {
    return TransactionType.expense;
  } else if (incomeCategories.contains(category)) {
    return TransactionType.income;
  } else {
    return TransactionType.transfer;
  }
}

// * provide the appropriate category list based on the transaction type
final categoriesProvider =
    StateNotifierProvider<CategoryListNotifier, List<Category>>(
  (_) => CategoryListNotifier(),
);

// * provide a list of expense categories
final expenseCategoriesProvider = Provider<List<Category>>(
  (ref) => expenseCategories,
);

// * provide a list of income categories
final incomeCategoriesProvider = Provider<List<Category>>(
  (ref) => incomeCategories,
);

class CategoryListNotifier extends StateNotifier<List<Category>> {
  CategoryListNotifier() : super([]);

  void updateCategoriesList(TransactionType type) {
    state = type == TransactionType.expense
        ? expenseCategories
        : type == TransactionType.income
            ? incomeCategories
            : [];
  }

  bool deleteCategory(Category category) {
    return state.remove(category);
  }

  void updateCategory(Category category) {
    state = state.map((existingCategory) {
      if (existingCategory.name == category.name) {
        return category;
      } else {
        return existingCategory;
      }
    }).toList();
  }
}

// * category components
final selectedCategoryColorProvider = StateProvider<Color>((ref) {
  final categoryColor = ref.watch(selectedCategoryProvider).color;
  return categoryColor;
});

Color? getCategoryColor(Category category) {
  return category.color;
}

final categoryColorListProvider = Provider<List<Color>>(
  (ref) => colorList,
);

final selectedCategoryIconProvider = StateProvider<IconData?>(
  (ref) => null,
);

final categoryIconListProvider = Provider<List<IconData>>(
  (ref) => iconList,
);

resetCategoryComponentsState(WidgetRef ref) {
  ref.read(selectedCategoryColorProvider.notifier).state = Colors.grey;
  ref.read(selectedCategoryIconProvider.notifier).state = null;
}
