import 'package:flutter/material.dart' show Color;
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';
// import 'package:pocketfi/src/features/timeline/transactions/strings.dart';

enum TransactionType {
  expense(
    symbol: Strings.expenseSymbol,
    color: Color(AppColors.expenseColor),
  ),
  income(
    symbol: Strings.incomeSymbol,
    color: Color(AppColors.incomeColor),
  ),
  transfer(
    symbol: Strings.transferSymbol,
    color: Color(AppColors.transferColor),
  );

  final String symbol;
  final Color color;

  const TransactionType({
    required this.symbol,
    required this.color,
  });
}
