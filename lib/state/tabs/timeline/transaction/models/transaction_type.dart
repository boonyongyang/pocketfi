import 'package:flutter/material.dart' show Color;
import 'package:pocketfi/state/category/models/category.dart';
import 'package:pocketfi/state/category/providers/category_provider.dart';
import 'package:pocketfi/state/tabs/timeline/transaction/constants/constants.dart';

enum TransactionType {
  expense(
    symbol: Constants.expenseSymbol,
    color: Color(Constants.expenseColor),
    // categories: Constants.expenseCategories,,
  ),
  income(
    symbol: Constants.incomeSymbol,
    color: Color(Constants.incomeColor),
    // categories: Constants.expenseCategories,
  ),
  transfer(
    symbol: Constants.transferSymbol,
    color: Color(Constants.transferColor),
    // categories: Constants.expenseCategories,
  );

  final String symbol;
  final Color color;
  // final Iterable<Category> categories;
  // final ExpenseCategory categories;

  const TransactionType({
    required this.symbol,
    required this.color,
    // required this.categories,
  });
}
