import 'package:flutter/material.dart';
import 'package:pocketfi/state/category/providers/category_provider.dart';
import 'package:pocketfi/views/constants/app_colors.dart';

class Category {
  final String name;
  final Color color;
  final Icon icon;
  final bool isSelected;

  const Category({
    required this.name,
    required this.color,
    required this.icon,
    this.isSelected = false,
  });

  Category copyWith({
    required bool isSelected,
  }) =>
      Category(
        name: name,
        color: color,
        icon: icon,
        // isSelected: isSelected,
      );

  @override
  bool operator ==(covariant Category other) =>
      name == other.name && isSelected == other.isSelected;

  @override
  int get hashCode => Object.hashAll([
        name,
        isSelected,
      ]);
}
