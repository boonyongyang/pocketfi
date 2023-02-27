import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/src/constants/firebase_field_name.dart';

@immutable
class BudgetPayload extends MapView<String, dynamic> {
  BudgetPayload({
    required String budgetId,
    required String budgetName,
    required double budgetAmount,
    required double usedAmount,
    required DateTime createdAt,
  }) : super({
          FirebaseFieldName.budgetId: budgetId,
          FirebaseFieldName.budgetName: budgetName,
          FirebaseFieldName.budgetAmount: budgetAmount,
          FirebaseFieldName.usedAmount: usedAmount,
          FirebaseFieldName.createdAt: FieldValue.serverTimestamp(),
        });
}
