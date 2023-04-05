import 'package:flutter/material.dart';

class Tag {
  final String name; // id
  final bool isSelected;
  final String userId;
  // final String walletId;
  // final String walletName;

  const Tag({
    required this.name,
    this.isSelected = false,
    required this.userId,
    // required this.walletId,
    // required this.walletName,
  });

  Tag.fromJson({
    required name,
    required Map<String, dynamic> json,
  }) : this(
          name: name,
          // walletName: json[TagKey.walletName],
          // walletId: json[TagKey.walletId],
          userId: json[TagKey.userId],
          isSelected: json[TagKey.isSelected] ?? false,
        );

  Map<String, dynamic> toJson() => {
        TagKey.name: name,
        TagKey.userId: userId,
        // TagKey.walletName: walletName,
        // TagKey.walletId: walletId,
        TagKey.isSelected: isSelected,
      };

  Tag copyWith({
    String? name,
    String? userId,
    bool? isSelected,
    // String? walletId,
    // String? walletName,
  }) =>
      Tag(
        name: name ?? this.name,
        userId: userId ?? this.userId,
        isSelected: isSelected ?? this.isSelected,
        // walletId: walletId ?? this.walletId,
        // walletName: walletName ?? this.walletName,
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
