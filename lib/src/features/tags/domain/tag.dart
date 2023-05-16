import 'package:flutter/material.dart';

class Tag {
  final String name;
  final bool isSelected;
  final String userId;

  const Tag({
    required this.name,
    this.isSelected = false,
    required this.userId,
  });

  Tag.fromJson({
    required name,
    required Map<String, dynamic> json,
  }) : this(
          name: name,
          userId: json[TagKey.userId],
          isSelected: json[TagKey.isSelected] ?? false,
        );

  Map<String, dynamic> toJson() => {
        TagKey.name: name,
        TagKey.userId: userId,
        TagKey.isSelected: isSelected,
      };

  Tag copyWith({
    String? name,
    String? userId,
    bool? isSelected,
  }) =>
      Tag(
        name: name ?? this.name,
        userId: userId ?? this.userId,
        isSelected: isSelected ?? this.isSelected,
      );
}

@immutable
class TagKey {
  static const userId = 'uid';
  static const name = 'name';
  static const walletName = 'walletName';
  static const walletId = 'walletId';
  static const isSelected = 'isSelected';
}
