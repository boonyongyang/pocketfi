import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/src/constants/firebase_names.dart';

@immutable
class SavingGoalHistory {
  final String savingGoalHistoryId;
  final String savingGoalId;
  final double savingGoalSavedAmount;
  final DateTime savingGoalSavedDate;
  final DateTime? createdAt;

  const SavingGoalHistory({
    required this.savingGoalHistoryId,
    required this.savingGoalId,
    required this.savingGoalSavedAmount,
    required this.savingGoalSavedDate,
    this.createdAt,
  });

  SavingGoalHistory.fromJson(Map<String, dynamic> json)
      : savingGoalHistoryId = json[FirebaseFieldName.savingGoalHistoryId],
        savingGoalId = json[FirebaseFieldName.savingGoalId],
        savingGoalSavedAmount = json[FirebaseFieldName.savingGoalSavedAmount],
        savingGoalSavedDate =
            (json[FirebaseFieldName.savingGoalSavedDate] as Timestamp).toDate(),
        createdAt = (json[FirebaseFieldName.createdAt] as Timestamp).toDate();

  Map<String, dynamic> toJson() => {
        FirebaseFieldName.savingGoalHistoryId: savingGoalHistoryId,
        FirebaseFieldName.savingGoalId: savingGoalId,
        FirebaseFieldName.savingGoalSavedAmount: savingGoalSavedAmount,
        FirebaseFieldName.savingGoalSavedDate: FieldValue.serverTimestamp(),
        FirebaseFieldName.createdAt: FieldValue.serverTimestamp(),
      };
}
