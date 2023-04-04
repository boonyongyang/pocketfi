import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/category/application/category_services.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/transactions/application/transaction_services.dart';
import 'package:pocketfi/src/features/transactions/data/transaction_repository.dart';
import 'package:pocketfi/src/features/transactions/date_picker/application/transaction_date_services.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';

// returns the total expense amount of all transactions of the current month
final totalAmountProvider = Provider.autoDispose<double>((ref) {
  final transactionList = ref.watch(userTransactionsProvider);
  double totalAmount = 0.0;
  // if (transactionList.hasValue && transactionList.value != null) {
  if (transactionList.hasValue) {
    final transactions = transactionList.value ?? [];
    for (final transaction in transactions) {
      if (transaction.type == TransactionType.expense) {
        totalAmount -= transaction.amount;
      } else if (transaction.type == TransactionType.income) {
        totalAmount += transaction.amount;
      }
    }
  }
  return totalAmount;
});

// returns the list of transactions for the current month
final currentMonthTransactionsProvider =
    Provider.autoDispose<List<Transaction>>((ref) {
  final transactionList = ref.watch(userTransactionsProvider);
  final month = ref.watch(overviewMonthProvider);
  if (transactionList.hasValue) {
    final transactions = transactionList.value ?? [];
    return transactions.where((tran) {
      // if data is empty, then the where function will return an empty list
      return tran.date.month == month.month && tran.date.year == month.year;
    }).toList();
  }
  return [];
});

// returns the list of categories that have transactions in the current month
final filteredCategoriesProvider = Provider.autoDispose<List<Category>>((ref) {
  final categories = ref.watch(categoriesProvider);
  final currentMonthTransactions = ref.watch(currentMonthTransactionsProvider);

  final filteredCategories = categories.where((category) {
    return currentMonthTransactions.any((tran) {
      return tran.categoryName == category.name;
    });
  }).toList()
    ..sort((a, b) {
      final aTotalAmount = getCategoryTotalAmountForCurrentMonth(
          a.name, currentMonthTransactions);
      final bTotalAmount = getCategoryTotalAmountForCurrentMonth(
          b.name, currentMonthTransactions);
      return bTotalAmount.compareTo(aTotalAmount);
    });

  return filteredCategories;
});

// to calculate the total amount for a category in the current month
double getCategoryTotalAmountForCurrentMonth(
    String categoryName, List<Transaction> transactions) {
  final categoryTransactions =
      transactions.where((tran) => tran.categoryName == categoryName);
  return getTotalAmount(categoryTransactions.toList());
}

double getTotalAmount(List<Transaction> transactions) {
  return transactions.fold<double>(
    0,
    (previousValue, element) => previousValue + element.amount,
  );
}

// returns the total amount of a specific category
final categoryTotalAmountForCurrentMonthProvider =
    Provider.autoDispose.family<double, String>((ref, categoryName) {
  final transactionList = ref.watch(currentMonthTransactionsProvider);

  final categoryTransactions =
      transactionList.where((tran) => tran.categoryName == categoryName);
  return getTotalAmount(categoryTransactions.toList());
});

// returns the total amount of a specific transaction type
final totalTypeAmountProvider = Provider.autoDispose<double>((ref) {
  final currentMonthTransactions = ref.watch(currentMonthTransactionsProvider);
  final transactionType = ref.watch(transactionTypeProvider);

  final transactionsOfType = currentMonthTransactions
      .where((tran) => tran.type == transactionType)
      .toList();
  final totalAmountOfType = getTotalAmount(transactionsOfType);

  return totalAmountOfType;
});
