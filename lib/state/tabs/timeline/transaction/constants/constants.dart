import 'package:flutter/foundation.dart' show immutable;

@immutable
class Constants {
  static const expenseSymbol = '-';
  static const incomeSymbol = '+';
  static const transferSymbol = '⇄';

  static const expenseColor = 0xFFF44336;
  static const incomeColor = 0xFF4CAF50;
  static const transferColor = 0xFF9E9E9E;

  // static const expenseStorageKey = 'expense';
  // static const incomeStorageKey = 'income';
  // static const transferStorageKey = 'transfer';

  const Constants._();
}
