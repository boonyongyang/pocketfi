import 'package:flutter/material.dart' show Color;
import 'package:pocketfi/state/tabs/timeline/transaction/constants/constants.dart';

enum TransactionType {
  expense(
    symbol: Constants.expenseSymbol,
    color: Color(Constants.expenseColor),
  ),
  income(
    symbol: Constants.incomeSymbol,
    color: Color(Constants.incomeColor),
  ),
  transfer(
    symbol: Constants.transferSymbol,
    color: Color(Constants.transferColor),
  );

  final String symbol;
  final Color color;

  const TransactionType({
    required this.symbol,
    required this.color,
  });
}
