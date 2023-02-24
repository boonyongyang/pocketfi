import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/category/models/category.dart';
import 'package:pocketfi/state/category/providers/category_provider.dart';
import 'package:pocketfi/state/tabs/timeline/transaction/notifiers/transaction_state_notifier.dart';

final selectedCategoryProvider = StateProvider<Category?>((ref) {
  final transactionTypeIndex = ref.watch(transactionTypeProvider);

  if (transactionTypeIndex == 0) {
    return expenseCategories.first;
  } else if (transactionTypeIndex == 1) {
    return incomeCategories.first;
  } else {
    return null;
  }
});

// final selectedCategoryProvider = StateProvider<Category>(
//   (ref) => expenseCategories.first,
// (ref) {
//   if (transaction == TransactionType.expense) {
//     return expenseCategories.first;
//   } else {
//     return incomeCategories.first;
//   }
// },
// );

// void updateSelectedCategory(Category category) {
//   selectedCategoryProvider.notifier = category;
// }

class CategoryNotifier extends StateNotifier<List<Category>> {
  CategoryNotifier() : super(expenseCategories);

  // set selectedCategoryProvider(Category category) {
  //   state = state
  //       .map(
  //         (thisCategory) => thisCategory.name == category.name
  //             ? thisCategory.copyWith(
  //                 isSelected: true,
  //               )
  //             : thisCategory.copyWith(
  //                 isSelected: false,
  //               ),
  //       )
  //       .toList();
  // }

  // void getTransactionCategories(TransactionType transactionType) {
  //   if (transactionType == TransactionType.expense) {
  //     state = expenseCategories;
  //   } else {
  //     state = incomeCategories;
  //   }
  // }

  void updateCategoriesList(List<Category> categories) {
    state = categories;
  }

  void setCategory(Category category, bool isSelected) {
    state = state
        .map(
          (thisCategory) => thisCategory.name == category.name
              ? thisCategory.copyWith(
                  isSelected: isSelected,
                )
              : thisCategory,
        )
        .toList();

    // run through all the categories and if the isSelected is true,
    // then change the color of the icon from black to white
    // if the isSelected is false, then change the color of the icon from white to black
  }
}
