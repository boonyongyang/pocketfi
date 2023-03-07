import 'package:flutter/material.dart';

class Category {
  final String name; // id
  final Color color;
  final Icon icon;
  final bool isSelected;

  const Category({
    required this.name,
    required this.color,
    required this.icon,
    this.isSelected = false,
  });

// todo : this is not used yet, should it be for CRUD Category?
// todo : is the isSelected property needed?
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

  // factory Category.fromJson(Map<String, dynamic> json) {
  //   return Category(
  //     name: json[CategoryKey.name],
  //     color: Color(json[CategoryKey.color]),
  //     icon: Icon(json[CategoryKey.icon]),
  //     isSelected: json[CategoryKey.isSelected] ?? false,
  //   );
  // }

  Category.fromJson({
    required name,
    required Map<String, dynamic> jsoon,
  }) : this(
          name: name,
          color: Color(jsoon[CategoryKey.color]),
          icon: Icon(jsoon[CategoryKey.icon]),
          isSelected: jsoon[CategoryKey.isSelected] ?? false,
        );
}

@immutable
class CategoryKey {
  static const name = 'name';
  static const color = 'color';
  static const icon = 'icon';
  static const isSelected = 'isSelected';
}
