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
    double remainingAmountToSave = savingGoalAmount - savingGoalSavedAmount;
    DateTime todayDate = DateTime.now();
    if (todayDate.difference(startDate).inDays == 0) {
      final differenceInDays = dueDate.difference(startDate).inDays;

      return remainingAmountToSave / differenceInDays;
    } else if (todayDate.isAfter(startDate) && todayDate.isBefore(dueDate)) {
      final differenceInDaysToday = todayDate.difference(startDate).inDays;

      return remainingAmountToSave / differenceInDaysToday;
    } else if (startDate.difference(todayDate).inDays < 0) {
      return 0;
    }

    if (todayDate.difference(dueDate).inDays == 1) {
      return remainingAmountToSave;
    }
    return amountToSavePerDay;
  }

  double calculateSavingsPerWeek() {
    double amountToSavePerWeek = 0;
    int daysInAWeek = 7;
    DateTime todayDate = DateTime.now();
    double remainingAmountToSave = savingGoalAmount - savingGoalSavedAmount;

    if (todayDate.difference(startDate).inDays == 0) {
      final differenceInWeeks =
          dueDate.difference(startDate).inDays / daysInAWeek;
      return remainingAmountToSave / differenceInWeeks;
    } else if (todayDate.isAfter(startDate) && todayDate.isBefore(dueDate)) {
      final differenceInWeeksToday =
          todayDate.difference(startDate).inDays / daysInAWeek;
      return remainingAmountToSave / differenceInWeeksToday;
    } else if (startDate.difference(todayDate).inDays < 0) {
      return 0;
    }

    if (todayDate.difference(dueDate).inDays == 1) {
      return remainingAmountToSave / daysInAWeek;
    }
    return amountToSavePerWeek;
  }

  double calculateSavingsPerMonth() {
    double amountToSavePerMonth = 0;
    DateTime todayDate = DateTime.now();
    double remainingAmountToSave = savingGoalAmount - savingGoalSavedAmount;

    int daysInAMonth = 30;

    if (todayDate.difference(startDate).inDays == 0) {
      final differenceInMonths =
          dueDate.difference(startDate).inDays / daysInAMonth;
      return remainingAmountToSave / differenceInMonths;
    } else if (todayDate.isAfter(startDate) && todayDate.isBefore(dueDate)) {
      final differenceInMonthsToday =
          todayDate.difference(startDate).inDays / daysInAMonth;
      return remainingAmountToSave / differenceInMonthsToday;
    } else if (startDate.difference(todayDate).inDays < 0) {
      return 0;
    }

    if (todayDate.difference(dueDate).inDays == 1) {
      return remainingAmountToSave / daysInAMonth;
    }
    return amountToSavePerMonth;
  }

  String daysLeft() {
    DateTime todayDate = DateTime.now();
    String remainingTime;
    Duration duration = dueDate.difference(todayDate);
    int days = duration.inDays;
    int years = (days / 365).floor();
    int remainingDays = days - (years * 365);
    int months = (remainingDays / 30).floor();
    remainingDays -= months * 30;

    if (days > 30) {
      remainingTime = '$months months $remainingDays days';
    } else if (days > 0) {
      remainingTime = '$days days';
    } else {
      remainingTime = 'Due date has passed';
    }

    if (years > 0) {
      remainingTime = '$years years $months months $remainingDays days';
    }

    return remainingTime;
  }

  int calculateDaysLeft() {
    DateTime todayDate = DateTime.now();
    Duration duration = dueDate.difference(todayDate);
    int days = duration.inDays;
    return days;
  }
}
