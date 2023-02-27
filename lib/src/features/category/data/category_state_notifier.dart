import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/category/domain/default_categories.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';

class CategoryNotifier extends StateNotifier<List<Category>> {
  CategoryNotifier() : super([]);

  void updateCategoriesList(TransactionType type) {
    state = type == TransactionType.expense
        ? expenseCategories
        : type == TransactionType.income
            ? incomeCategories
            : [];
  }

// todo : this isnot used?
  // void setCategory(Category category, bool isSelected) {
  //   state = state
  //       .map(
  //         (thisCategory) => thisCategory.name == category.name
  //             ? thisCategory.copyWith(
  //                 isSelected: isSelected,
  //               )
  //             : thisCategory,
  //       )
  //       .toList();
  // }
}
