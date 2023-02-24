import 'package:flutter/material.dart' show Color, debugPrint;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/tabs/timeline/transaction/constants/constants.dart';

enum TransactionType {
  expense(
    symbol: Constants.expenseSymbol,
    color: Color(Constants.expenseColor),
    // categories: expenseCategories,
  ),
  income(
    symbol: Constants.incomeSymbol,
    color: Color(Constants.incomeColor),
    // categories: incomeCategories,
  ),
  transfer(
    symbol: Constants.transferSymbol,
    color: Color(Constants.transferColor),
    // categories: [],
  );

  final String symbol;
  final Color color;
  // final List<Category> categories;

  const TransactionType({
    required this.symbol,
    required this.color,
    // required this.categories,
  });
}

// final transactionTypeProvider =
//     StateNotifierProvider<TransactionTypeNotifier, TransactionType>(
//   (ref) => TransactionTypeNotifier(),
// );

// class TransactionTypeNotifier extends StateNotifier<TransactionType> {
//   TransactionTypeNotifier() : super(TransactionType.expense) {
//     if (TransactionType.expense == TransactionType.expense) {
//       debugPrint("TransactionType.expense == TransactionType.expense");
//     } else {
//       debugPrint("TransactionType.expense != TransactionType.expense");
//     }
//   }

//   void setTransactionType(TransactionType transactionType) {
//     state = transactionType;
//   }
// }

// class TransactionTypeNotifier extends StateNotifier<int> {
//   TransactionTypeNotifier() : super(0);

//   void setTransactionType(int index) {
//     state = index;
//   }
// }

// final transactionTypeStateNotifierProvider =
//     StateNotifierProvider<TransactionTypeNotifier, int>(
//         (ref) => TransactionTypeNotifier());
