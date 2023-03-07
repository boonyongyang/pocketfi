import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/src/constants/firebase_names.dart';

@immutable
class BudgetPayload extends MapView<String, dynamic> {
  BudgetPayload({
    required String budgetId,
    required String budgetName,
    required double budgetAmount,
    required double usedAmount,
    required String walletId,
  }) : super({
          FirebaseFieldName.budgetId: budgetId,
          FirebaseFieldName.budgetName: budgetName,
          FirebaseFieldName.budgetAmount: budgetAmount,
          FirebaseFieldName.usedAmount: usedAmount,
          FirebaseFieldName.walletId: walletId,
          FirebaseFieldName.createdAt: FieldValue.serverTimestamp(),
        });
}
