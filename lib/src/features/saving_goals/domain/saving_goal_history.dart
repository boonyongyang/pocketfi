import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';

@immutable
class SavingGoalHistory {
  final String savingGoalHistoryId;
  final String savingGoalId;
  final double savingGoalEnterAmount;
  final DateTime savingGoalEnterDate;
  final String savingGoalStatus;
  final UserId userId;
  final String walletId;
  final DateTime? createdAt;

  const SavingGoalHistory({
    required this.savingGoalHistoryId,
    required this.savingGoalId,
    required this.savingGoalEnterAmount,
    required this.savingGoalStatus,
    required this.userId,
    required this.walletId,
    required this.savingGoalEnterDate,
    this.createdAt,
  });

  SavingGoalHistory.fromJson(Map<String, dynamic> json)
      : savingGoalHistoryId = json[FirebaseFieldName.savingGoalHistoryId],
        savingGoalId = json[FirebaseFieldName.savingGoalId],
        savingGoalEnterAmount = json[FirebaseFieldName.savingGoalSavedAmount],
        savingGoalStatus = json[FirebaseFieldName.savingGoalStatus],
        userId = json[FirebaseFieldName.userId] as UserId,
        walletId = json[FirebaseFieldName.walletId],
        savingGoalEnterDate =
            (json[FirebaseFieldName.savingGoalSavedDate] as Timestamp).toDate(),
        createdAt = (json[FirebaseFieldName.createdAt] as Timestamp).toDate();

  Map<String, dynamic> toJson() => {
        FirebaseFieldName.savingGoalHistoryId: savingGoalHistoryId,
        FirebaseFieldName.savingGoalId: savingGoalId,
        FirebaseFieldName.savingGoalSavedAmount: savingGoalEnterAmount,
        FirebaseFieldName.savingGoalStatus: savingGoalStatus,
        FirebaseFieldName.walletId: walletId,
        FirebaseFieldName.userId: userId,
        FirebaseFieldName.savingGoalSavedDate: FieldValue.serverTimestamp(),
        FirebaseFieldName.createdAt: FieldValue.serverTimestamp(),
      };
}

enum SavingGoalStatus {
  deposit,
  withdraw,
}
