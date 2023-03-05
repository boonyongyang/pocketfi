import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/src/constants/firebase_field_name.dart';
import 'package:pocketfi/src/constants/typedefs.dart';

@immutable
class Budget {
  final String budgetId;
  final String budgetName;
  final double budgetAmount;
  final double usedAmount;
  // final double remainingAmount;
  final DateTime createdAt;
  final String walletId;
  final UserId userId;

  Budget(Map<String, dynamic> json)
      : budgetId = json[FirebaseFieldName.budgetId],
        budgetName = json[FirebaseFieldName.budgetName],
        budgetAmount = json[FirebaseFieldName.budgetAmount],
        usedAmount = json[FirebaseFieldName.usedAmount],
        walletId = json[FirebaseFieldName.walletId],
        userId = json[FirebaseFieldName.userId] as UserId,
        // remainingAmount = json[FirebaseFieldName.remainingAmount],
        createdAt = (json[FirebaseFieldName.createdAt] as Timestamp).toDate();

  @override
  bool operator ==(covariant Budget other) =>
      runtimeType == other.runtimeType &&
      other.budgetId == budgetId &&
      other.budgetName == budgetName &&
      other.budgetAmount == budgetAmount &&
      other.createdAt == createdAt &&
      other.walletId == walletId &&
      other.userId == userId &&
      other.usedAmount == usedAmount;
  // other.remainingAmount == remainingAmount;

  @override
  int get hashCode => Object.hashAll(
        [
          budgetId,
          budgetName,
          budgetAmount,
          createdAt,
          walletId,
          userId,
          // remainingAmount,
          usedAmount,
        ],
      );
}
