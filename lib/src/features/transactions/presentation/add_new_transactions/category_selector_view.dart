import 'package:flutter/material.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';

class CategorySelectorView extends StatelessWidget {
  const CategorySelectorView({
    super.key,
    required this.selectedCategory,
  });

  final Category? selectedCategory;

  @override
  Widget build(BuildContext context) {
    if (selectedCategory == null) {
      return const SizedBox();
    } else {
      return Row(
        children: [
          CircleAvatar(
            backgroundColor: selectedCategory!.color,
            child: selectedCategory!.icon,
          ),
          const SizedBox(width: 8.0),
          Text(selectedCategory!.name),
        ],
      );
    }
  }
}
