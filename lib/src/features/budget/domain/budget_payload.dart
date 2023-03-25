import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';

@immutable
class BudgetPayload extends MapView<String, dynamic> {
  BudgetPayload({
    required String budgetId,
    required String budgetName,
    required double budgetAmount,
    required double usedAmount,
    required String categoryName,
    required String walletId,
    required UserId userId,
  }) : super({
          FirebaseFieldName.budgetId: budgetId,
          FirebaseFieldName.budgetName: budgetName,
          FirebaseFieldName.budgetAmount: budgetAmount,
          FirebaseFieldName.usedAmount: usedAmount,
          FirebaseFieldName.categoryName: categoryName,
          FirebaseFieldName.walletId: walletId,
          FirebaseFieldName.userId: userId,
          FirebaseFieldName.createdAt: FieldValue.serverTimestamp(),
        });
}
