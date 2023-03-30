import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';

@immutable
class SavingGoal {
  final String savingGoalId;
  final String savingGoalName;
  final double savingGoalAmount;
  final double savingGoalSavedAmount;
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
    this.savingGoalSavedAmount = 0.0,
    this.createdAt,
    required this.startDate,
    required this.dueDate,
  });

  SavingGoal.fromJson(Map<String, dynamic> json)
      : savingGoalId = json[FirebaseFieldName.savingGoalId],
        savingGoalName = json[FirebaseFieldName.savingGoalName],
        savingGoalAmount = json[FirebaseFieldName.savingGoalAmount],
        savingGoalSavedAmount = json[FirebaseFieldName.savingGoalSavedAmount],
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
        FirebaseFieldName.savingGoalSavedAmount: savingGoalSavedAmount,
        FirebaseFieldName.walletId: walletId,
        FirebaseFieldName.userId: userId,
        FirebaseFieldName.savingGoalDueDate: dueDate,
        FirebaseFieldName.savingGoalStartDate: startDate,
        FirebaseFieldName.createdAt: FieldValue.serverTimestamp(),
      };

  double calculateSavingsPerDay() {
    double amountToSavePerDay = 0;
    DateTime todayDate = DateTime.now();
    if (todayDate.difference(startDate).inDays == 0) {
      final differenceInDays = dueDate.difference(startDate).inDays;

      return savingGoalAmount / differenceInDays;
    } else if (todayDate.isAfter(startDate) && todayDate.isBefore(dueDate)) {
      final differenceInDaysToday = todayDate.difference(startDate).inDays;

      return savingGoalAmount / differenceInDaysToday;
    } else if (startDate.difference(todayDate).inDays < 0) {
      return 0;
    }

    if (todayDate.difference(dueDate).inDays == 1) {
      return savingGoalAmount - savingGoalSavedAmount;
    }
    return amountToSavePerDay;
  }

  double calculateSavingsPerWeek() {
    double amountToSavePerWeek = 0;
    int daysInAWeek = 7;
    DateTime todayDate = DateTime.now();

    // int daysInAMonth = 30;

    if (todayDate.difference(startDate).inDays == 0) {
      final differenceInWeeks =
          dueDate.difference(startDate).inDays / daysInAWeek;
      return savingGoalAmount / differenceInWeeks;
    } else if (todayDate.isAfter(startDate) && todayDate.isBefore(dueDate)) {
      final differenceInWeeksToday =
          todayDate.difference(startDate).inDays / daysInAWeek;
      return savingGoalAmount / differenceInWeeksToday;
    } else if (startDate.difference(todayDate).inDays < 0) {
      return 0;
    }

    if (todayDate.difference(dueDate).inDays == 1) {
      return (savingGoalAmount - savingGoalSavedAmount) / daysInAWeek;
    }
    return amountToSavePerWeek;
  }

  double calculateSavingsPerMonth() {
    double amountToSavePerMonth = 0;
    DateTime todayDate = DateTime.now();

    // int daysInAWeek = 7;
    int daysInAMonth = 30;

    if (todayDate.difference(startDate).inDays == 0) {
      final differenceInMonths =
          dueDate.difference(startDate).inDays / daysInAMonth;
      return savingGoalAmount / differenceInMonths;
    } else if (todayDate.isAfter(startDate) && todayDate.isBefore(dueDate)) {
      final differenceInMonthsToday =
          todayDate.difference(startDate).inDays / daysInAMonth;
      return savingGoalAmount / differenceInMonthsToday;
    } else if (startDate.difference(todayDate).inDays < 0) {
      return 0;
    }

    if (todayDate.difference(dueDate).inDays == 1) {
      return (savingGoalAmount - savingGoalSavedAmount) / daysInAMonth;
    }
    return amountToSavePerMonth;
  }

  int calculateDaysLeft() {
    DateTime todayDate = DateTime.now();
    final differenceInDays = dueDate.difference(todayDate).inDays;
    return differenceInDays;
  }
}
