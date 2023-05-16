import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';

@immutable
class Budget {
  final String budgetId;
  final String budgetName;
  final double budgetAmount;
  final double usedAmount;
  final String categoryName;
  final String ownerId;
  final DateTime? createdAt;
  final String walletId;
  final UserId userId;

  const Budget({
    required this.budgetId,
    required this.budgetName,
    required this.budgetAmount,
    required this.usedAmount,
    required this.categoryName,
    required this.ownerId,
    this.createdAt,
    required this.walletId,
    required this.userId,
  });

  Budget.fromJson(Map<String, dynamic> json)
      : budgetId = json[FirebaseFieldName.budgetId],
        budgetName = json[FirebaseFieldName.budgetName],
        budgetAmount = json[FirebaseFieldName.budgetAmount],
        usedAmount = json[FirebaseFieldName.usedAmount],
        walletId = json[FirebaseFieldName.walletId],
        userId = json[FirebaseFieldName.userId] as UserId,
        ownerId = json[FirebaseFieldName.ownerId],
        categoryName = json[FirebaseFieldName.categoryName],
        createdAt = (json[FirebaseFieldName.createdAt] as Timestamp).toDate();

  Map<String, dynamic> toJson() => {
        FirebaseFieldName.budgetId: budgetId,
        FirebaseFieldName.budgetName: budgetName,
        FirebaseFieldName.budgetAmount: budgetAmount,
        FirebaseFieldName.usedAmount: usedAmount,
        FirebaseFieldName.categoryName: categoryName,
        FirebaseFieldName.ownerId: ownerId,
        FirebaseFieldName.walletId: walletId,
        FirebaseFieldName.userId: userId,
        FirebaseFieldName.createdAt: FieldValue.serverTimestamp(),
      };

  Budget copyWith({
    String? budgetId,
    String? budgetName,
    double? budgetAmount,
    double? usedAmount,
    String? categoryName,
    double? remainingAmount,
    DateTime? createdAt,
    String? ownerId,
    String? walletId,
    UserId? userId,
  }) {
    return Budget(
      budgetId: budgetId ?? this.budgetId,
      budgetName: budgetName ?? this.budgetName,
      budgetAmount: budgetAmount ?? this.budgetAmount,
      usedAmount: usedAmount ?? this.usedAmount,
      categoryName: categoryName ?? this.categoryName,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      walletId: walletId ?? this.walletId,
      userId: userId ?? this.userId,
    );
  }
}
