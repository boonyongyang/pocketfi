import 'package:flutter/material.dart' show Color;
import 'package:pocketfi/state/timeline/transaction//constants/constants.dart';

enum TransactionType {
  expense(
    symbol: Constants.expenseSymbol,
    color: Color(Constants.expenseColor),
    // storageKey: Constants.expenseStorageKey,
  ),
  income(
    symbol: Constants.incomeSymbol,
    color: Color(Constants.incomeColor),
    // storageKey: Constants.incomeStorageKey,
  ),
  transfer(
    symbol: Constants.transferSymbol,
    color: Color(Constants.transferColor),
    // storageKey: Constants.transferStorageKey,
  );

  final String symbol;
  final Color color;
  // final String storageKey;

  const TransactionType({
    required this.symbol,
    required this.color,
    // required this.storageKey,
  });
}
