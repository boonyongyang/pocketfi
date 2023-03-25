import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';

@immutable
class BudgetPayload extends MapView<String, dynamic> {
  BudgetPayload({
    required String debtId,
    required String debtName,
    required double debtAmount,
    required double paidAmount,
    DateTime? createdAt,
    required String walletId,
    required UserId userId,
    required DateTime recurringDateToPay,
  }) : super({
          FirebaseFieldName.debtId: debtId,
          FirebaseFieldName.debtName: debtName,
          FirebaseFieldName.debtAmount: debtAmount,
          FirebaseFieldName.minimumPayment: paidAmount,
          FirebaseFieldName.createdAt: FieldValue.serverTimestamp(),
          FirebaseFieldName.walletId: walletId,
          FirebaseFieldName.userId: userId,
          FirebaseFieldName.recurringDateToPay: recurringDateToPay,
        });
}
