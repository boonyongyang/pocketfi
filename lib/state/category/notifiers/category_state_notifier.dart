import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/category/models/category.dart';
import 'package:pocketfi/state/category/providers/category_provider.dart';

final selectedCategoryProvider = StateProvider<Category>(
  (ref) => expenseCategories.first,
);

class CategoryNotifier extends StateNotifier<List<Category>> {
  CategoryNotifier() : super(expenseCategories);

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
    // then cahnge the color of the icon from black to white
    // if the isSelected is false, then change the color of the icon from white to black
  }
}
