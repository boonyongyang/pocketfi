import 'package:flutter/material.dart';

@immutable
class CalculateSavings {
  final DateTime startDate;
  final DateTime todayDate;
  final DateTime dueDate;
  final double savingGoalAmount;
  final double amountSaved;

  const CalculateSavings({
    required this.startDate,
    required this.todayDate,
    required this.dueDate,
    required this.savingGoalAmount,
    required this.amountSaved,
  });

  double calculateSavingsPerDay() {
    double amountToSavePerDay = 0;
    if (todayDate.difference(startDate).inDays == 0) {
      final differenceInDays = dueDate.difference(startDate).inDays;
      debugPrint(
          'amountToSavePerDay if startdate = due: ${savingGoalAmount / differenceInDays}');
      debugPrint('difference in days if startdate = due: $differenceInDays');
      return savingGoalAmount / differenceInDays;
    } else if (todayDate.isAfter(startDate) && todayDate.isBefore(dueDate)) {
      final differenceInDaysToday = todayDate.difference(startDate).inDays;
      debugPrint(
          'amountToSavePerDay if start > due : ${savingGoalAmount / differenceInDaysToday}');
      debugPrint(
          'difference in days if startdate = due: $differenceInDaysToday');
      return savingGoalAmount / differenceInDaysToday;
    } else if (startDate.difference(todayDate).inDays < 0) {
      return 0;
    }

    if (todayDate.difference(dueDate).inDays == 1) {
      return savingGoalAmount - amountSaved;
    }
    return amountToSavePerDay;
  }

  int calculateDaysLeft() {
    final differenceInDays = dueDate.difference(todayDate).inDays;
    debugPrint('differenceInDays: $differenceInDays');
    return differenceInDays;
  }
}
