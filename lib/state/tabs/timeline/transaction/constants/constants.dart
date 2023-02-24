import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart' show Icons;

@immutable
class Constants {
  static const expenseSymbol = '-';
  static const incomeSymbol = '+';
  static const transferSymbol = '⇄';

  static const expenseColor = 0xFFF44336;
  static const incomeColor = 0xFF4CAF50;
  static const transferColor = 0xFF9E9E9E;

  static const expenseIcon = Icons.arrow_downward;
  static const incomeIcon = Icons.arrow_upward;
  static const transferIcon = Icons.compare_arrows;

  static const selectCategory = 'Select Category';
  static const addAPhoto = 'Add a photo';
  static const writeANote = 'Write a note';
  static const newTransaction = 'New Transaction';
  static const editTransaction = 'Edit Transaction';
  static const zeroAmount = '0';

  const Constants._();
}
