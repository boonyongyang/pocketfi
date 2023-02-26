import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/category/models/category.dart';

class CategoryNotifier extends StateNotifier<List<Category>> {
  CategoryNotifier() : super([]);

  void updateCategoriesList(List<Category> categoriesList) {
    state = categoriesList;
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
