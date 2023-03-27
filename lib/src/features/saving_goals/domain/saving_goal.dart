import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';

@immutable
class SavingGoal {
  final String savingGoalId;
  final String savingGoalName;
  final double savingGoalAmount;
  final double savingGoalCurrentAmount;
  final DateTime? createdAt;
  final String walletId;
  final UserId userId;
  final DateTime startDate;
  final DateTime dueDate;
  // final double savedAmount;

  const SavingGoal({
    required this.savingGoalId,
    required this.savingGoalName,
    required this.savingGoalAmount,
    required this.walletId,
    required this.userId,
    this.savingGoalCurrentAmount = 0.0,
    this.createdAt,
    required this.startDate,
    required this.dueDate,
  });

  SavingGoal.fromJson(Map<String, dynamic> json)
      : savingGoalId = json[FirebaseFieldName.savingGoalId],
        savingGoalName = json[FirebaseFieldName.savingGoalName],
        savingGoalAmount = json[FirebaseFieldName.savingGoalAmount],
        savingGoalCurrentAmount =
            json[FirebaseFieldName.savingGoalCurrentAmount],
        walletId = json[FirebaseFieldName.walletId],
        userId = json[FirebaseFieldName.userId] as UserId,
        dueDate =
            (json[FirebaseFieldName.savingGoalDueDate] as Timestamp).toDate(),
        startDate =
            (json[FirebaseFieldName.savingGoalStartDate] as Timestamp).toDate(),
        createdAt = (json[FirebaseFieldName.createdAt] as Timestamp).toDate();

  Map<String, dynamic> toJson() => {
        FirebaseFieldName.savingGoalId: savingGoalId,
        FirebaseFieldName.savingGoalName: savingGoalName,
        FirebaseFieldName.savingGoalAmount: savingGoalAmount,
        FirebaseFieldName.savingGoalCurrentAmount: savingGoalCurrentAmount,
        FirebaseFieldName.walletId: walletId,
        FirebaseFieldName.userId: userId,
        FirebaseFieldName.savingGoalDueDate: dueDate,
        FirebaseFieldName.savingGoalStartDate: startDate,
        FirebaseFieldName.createdAt: FieldValue.serverTimestamp(),
      };
}
