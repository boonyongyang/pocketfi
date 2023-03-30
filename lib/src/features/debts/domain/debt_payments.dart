import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';

@immutable
class DebtPayment {
  final String debtPaymentId;
  final String debtId;
  final String userId;
  final double interestAmount;
  final double principleAmount;
  final double newBalance;
  final double previousBalance;
  final String paidMonth;
  final DateTime? paymentDate;
  final bool isPaid;
  final String walletId;
  final String transactionId;

  const DebtPayment({
    required this.debtPaymentId,
    required this.debtId,
    required this.userId,
    required this.interestAmount,
    required this.principleAmount,
    required this.newBalance,
    required this.previousBalance,
    required this.paidMonth,
    this.paymentDate,
    required this.isPaid,
    required this.walletId,
    required this.transactionId,
  });

  DebtPayment.fromJson(Map<String, dynamic> json)
      : debtPaymentId = json[FirebaseFieldName.debtPaymentId],
        debtId = json[FirebaseFieldName.debtId],
        userId = json[FirebaseFieldName.userId],
        interestAmount = json[FirebaseFieldName.interestAmount],
        principleAmount = json[FirebaseFieldName.principleAmount],
        newBalance = json[FirebaseFieldName.newBalance],
        previousBalance = json[FirebaseFieldName.previousBalance],
        paymentDate =
            (json[FirebaseFieldName.paymentDate] as Timestamp).toDate(),
        paidMonth = json[FirebaseFieldName.paidMonth],
        walletId = json[FirebaseFieldName.walletId],
        transactionId = json[FirebaseFieldName.transactionId],
        isPaid = json[FirebaseFieldName.isPaid];

  Map<String, dynamic> toJson() => {
        FirebaseFieldName.debtPaymentId: debtPaymentId,
        FirebaseFieldName.debtId: debtId,
        FirebaseFieldName.userId: userId,
        FirebaseFieldName.interestAmount: interestAmount,
        FirebaseFieldName.principleAmount: principleAmount,
        FirebaseFieldName.newBalance: newBalance,
        FirebaseFieldName.previousBalance: previousBalance,
        FirebaseFieldName.paidMonth: paidMonth,
        FirebaseFieldName.paymentDate: FieldValue.serverTimestamp(),
        FirebaseFieldName.walletId: walletId,
        FirebaseFieldName.transactionId: transactionId,
        FirebaseFieldName.isPaid: isPaid,
      };

  DebtPayment copyWith({
    String? debtPaymentId,
    String? debtId,
    UserId? userId,
    double? interestAmount,
    double? principleAmount,
    double? previousBalance,
    double? newBalance,
    String? paidMonth,
    DateTime? paymentDate,
    bool? isPaid,
    String? transactionId,
    String? walletId,
  }) {
    return DebtPayment(
      debtPaymentId: debtPaymentId ?? this.debtPaymentId,
      debtId: debtId ?? this.debtId,
      userId: userId ?? this.userId,
      interestAmount: interestAmount ?? this.interestAmount,
      principleAmount: principleAmount ?? this.principleAmount,
      newBalance: newBalance ?? this.newBalance,
      previousBalance: previousBalance ?? this.previousBalance,
      paidMonth: paidMonth ?? this.paidMonth,
      paymentDate: paymentDate ?? this.paymentDate,
      walletId: walletId ?? this.walletId,
      transactionId: transactionId ?? this.transactionId,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}
