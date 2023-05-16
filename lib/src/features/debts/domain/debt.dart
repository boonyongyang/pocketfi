import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:intl/intl.dart';

import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';

@immutable
class Debt {
  final String debtId;
  final String debtName;
  final double debtAmount;
  final double minimumPayment;
  final double annualInterestRate;
  final DateTime? createdAt;
  final String walletId;
  final UserId userId;
  final String frequency;
  final int totalNumberOfMonthsToPay;
  final double lastMonthInterest;
  final double lastMonthPrinciple;

  const Debt({
    required this.debtId,
    required this.debtName,
    required this.debtAmount,
    required this.minimumPayment,
    required this.walletId,
    required this.userId,
    required this.annualInterestRate,
    required this.totalNumberOfMonthsToPay,
    required this.lastMonthPrinciple,
    required this.lastMonthInterest,
    this.frequency = 'Monthly',
    this.createdAt,
  });

  Debt.fromJson(Map<String, dynamic> json)
      : debtId = json[FirebaseFieldName.debtId],
        debtName = json[FirebaseFieldName.debtName],
        debtAmount = json[FirebaseFieldName.debtAmount],
        minimumPayment = json[FirebaseFieldName.minimumPayment],
        walletId = json[FirebaseFieldName.walletId],
        userId = json[FirebaseFieldName.userId] as UserId,
        annualInterestRate = json[FirebaseFieldName.annualInterestRate],
        frequency = json[FirebaseFieldName.frequency],
        totalNumberOfMonthsToPay =
            json[FirebaseFieldName.totalNumberOfMonthsToPay],
        lastMonthInterest = json[FirebaseFieldName.lastMonthInterest],
        lastMonthPrinciple = json[FirebaseFieldName.lastMonthPrinciple],
        createdAt = (json[FirebaseFieldName.createdAt] as Timestamp).toDate();

  Map<String, dynamic> toJson() => {
        FirebaseFieldName.debtId: debtId,
        FirebaseFieldName.debtName: debtName,
        FirebaseFieldName.debtAmount: debtAmount,
        FirebaseFieldName.minimumPayment: minimumPayment,
        FirebaseFieldName.frequency: frequency,
        FirebaseFieldName.walletId: walletId,
        FirebaseFieldName.userId: userId,
        FirebaseFieldName.annualInterestRate: annualInterestRate,
        FirebaseFieldName.totalNumberOfMonthsToPay: totalNumberOfMonthsToPay,
        FirebaseFieldName.lastMonthInterest: lastMonthInterest,
        FirebaseFieldName.lastMonthPrinciple: lastMonthPrinciple,
        FirebaseFieldName.createdAt: FieldValue.serverTimestamp(),
      };

  Debt copyWith({
    String? debtId,
    String? debtName,
    double? debtAmount,
    double? minimumPayment,
    String? frequency,
    String? walletId,
    UserId? userId,
    double? annualInterestRate,
    double? lastMonthInterest,
    double? lastMonthPrinciple,
    int? totalNumberOfMonthsToPay,
    DateTime? createdAt,
  }) {
    return Debt(
      debtId: debtId ?? this.debtId,
      debtName: debtName ?? this.debtName,
      debtAmount: debtAmount ?? this.debtAmount,
      minimumPayment: minimumPayment ?? this.minimumPayment,
      frequency: frequency ?? this.frequency,
      walletId: walletId ?? this.walletId,
      userId: userId ?? this.userId,
      annualInterestRate: annualInterestRate ?? this.annualInterestRate,
      totalNumberOfMonthsToPay:
          totalNumberOfMonthsToPay ?? this.totalNumberOfMonthsToPay,
      lastMonthInterest: lastMonthInterest ?? this.lastMonthInterest,
      lastMonthPrinciple: lastMonthPrinciple ?? this.lastMonthPrinciple,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(covariant Debt other) =>
      runtimeType == other.runtimeType &&
      other.debtId == debtId &&
      other.debtName == debtName &&
      other.debtAmount == debtAmount &&
      other.createdAt == createdAt &&
      other.annualInterestRate == annualInterestRate &&
      other.frequency == frequency &&
      other.totalNumberOfMonthsToPay == totalNumberOfMonthsToPay &&
      other.lastMonthInterest == lastMonthInterest &&
      other.lastMonthPrinciple == lastMonthPrinciple &&
      other.walletId == walletId &&
      other.userId == userId &&
      other.minimumPayment == minimumPayment;

  @override
  int get hashCode => Object.hashAll(
        [
          debtId,
          debtName,
          debtAmount,
          createdAt,
          lastMonthInterest,
          lastMonthPrinciple,
          frequency,
          walletId,
          annualInterestRate,
          totalNumberOfMonthsToPay,
          userId,
          minimumPayment,
        ],
      );

  List<Map<String, dynamic>> debtLoanInTable() {
    int createdMonth = createdAt!.month;

    double endBalance = debtAmount;
    double monthlyInterestRate = (annualInterestRate / 100) / 12;
    double interest = 0;
    double principle = 0;
    int months = createdMonth - 1;

    List<Map<String, dynamic>> tableData = [];

    while (endBalance > 0 && endBalance > minimumPayment) {
      interest = endBalance * monthlyInterestRate;
      endBalance = endBalance + interest - minimumPayment;
      principle = minimumPayment - interest;
      months++;
      String monthName = DateFormat('MMM yyyy').format(
        DateTime(createdAt!.year, months),
      );
      Map<String, dynamic> rowData = {
        'month': monthName,
        'interest': interest.toStringAsFixed(2),
        'principle': principle.toStringAsFixed(2),
        'endBalance': endBalance.toStringAsFixed(2),
      };

      tableData.add(rowData);
    }

    interest = endBalance * monthlyInterestRate;
    principle = endBalance;
    endBalance = 0.00;
    months++;

    String monthName = DateFormat('MMM yyyy').format(
      DateTime(createdAt!.year, months),
    );

    Map<String, dynamic> rowData = {
      'month': monthName,
      'interest': interest.toStringAsFixed(2),
      'principle': principle.toStringAsFixed(2),
      'endBalance': endBalance.toStringAsFixed(2),
    };

    tableData.add(rowData);

    return tableData;
  }

  double calculateTotalPayment() {
    int createdMonth = createdAt!.month;

    double endBalance = debtAmount;
    double monthlyInterestRate = (annualInterestRate / 100) / 12;
    double interest = 0;
    double principle = 0;
    // ignore: unused_local_variable
    int months = createdMonth - 1;
    double totalPayment = 0.00;

    while (endBalance > 0 && endBalance > minimumPayment) {
      interest = endBalance * monthlyInterestRate;
      endBalance = endBalance + interest - minimumPayment;
      principle = minimumPayment - interest;
      months++;
      totalPayment += minimumPayment;
    }

    interest = endBalance * monthlyInterestRate;
    principle = endBalance;
    endBalance = 0.00;
    months++;
    totalPayment += principle + interest;

    return totalPayment;
  }
}
