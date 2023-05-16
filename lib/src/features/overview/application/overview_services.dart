import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/category/application/category_services.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/tags/application/tag_services.dart';
import 'package:pocketfi/src/features/tags/domain/tag.dart';
import 'package:pocketfi/src/features/transactions/application/transaction_services.dart';
import 'package:pocketfi/src/features/transactions/data/transaction_repository.dart';
import 'package:pocketfi/src/features/shared/date_picker/application/date_services.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';

// returns the total expense amount of all transactions of the current month
final totalAmountProvider = Provider.autoDispose<double>((ref) {
  final transactionList = ref.watch(userTransactionsProvider);
  double totalAmount = 0.0;
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
final currentMonthTransactionsProvider = Provider<List<Transaction>>((ref) {
  final transactionList = ref.watch(userTransactionsProvider);
  final month = ref.watch(overviewMonthProvider);
  if (transactionList.hasValue) {
    final transactions = transactionList.value ?? [];
    return transactions.where((tran) {
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

// returns the list of tags that have transactions in the current month
final filteredTagsProvider = Provider.autoDispose<List<Tag>>((ref) {
  final tags = ref.watch(userTagsNotifier);
  final currentMonthTransactions = ref.watch(currentMonthTransactionsProvider);

  final filteredTags = tags.where((tag) {
    return currentMonthTransactions.any((tran) {
      return tran.tags.contains(tag.name);
    });
  }).toList()
    ..sort((a, b) {
      final aTotalAmount =
          getTagTotalAmountForCurrentMonth(a.name, currentMonthTransactions);
      final bTotalAmount =
          getTagTotalAmountForCurrentMonth(b.name, currentMonthTransactions);
      return bTotalAmount.compareTo(aTotalAmount);
    });

  return filteredTags;
});

final filteredTagsByTypeProvider =
    Provider.autoDispose.family<List<Tag>, TransactionType>((ref, type) {
  final tags = ref.watch(userTagsNotifier);
  final currentMonthTransactions = ref.watch(currentMonthTransactionsProvider);

  final filteredTags = tags.where((tag) {
    return currentMonthTransactions.any((tran) {
      return tran.tags.contains(tag.name) && tran.type == type;
    });
  }).toList()
    ..sort((a, b) {
      final aTotalAmount =
          getTagTotalAmountForCurrentMonth(a.name, currentMonthTransactions);
      final bTotalAmount =
          getTagTotalAmountForCurrentMonth(b.name, currentMonthTransactions);
      return bTotalAmount.compareTo(aTotalAmount);
    });

  return filteredTags;
});

// to calculate the total amount for a category in the current month
double getTagTotalAmountForCurrentMonth(
    String tagName, List<Transaction> transactions) {
  final tagTransactions =
      transactions.where((tran) => tran.tags.contains(tagName));
  return getTotalAmount(tagTransactions.toList());
}

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

// returns the total amount of a specific transaction type
final monthlyCashFlowProvider = Provider.autoDispose<double>((ref) {
  final currentMonthTransactions = ref.watch(currentMonthTransactionsProvider);
  final totalIncome = currentMonthTransactions
      .where((tran) => tran.type == TransactionType.income)
      .toList();
  final totalExpense = currentMonthTransactions
      .where((tran) => tran.type == TransactionType.expense)
      .toList();
  final incomeAmount = getTotalAmount(totalIncome);
  final expenseAmount = getTotalAmount(totalExpense);
  final monthlyCashFlow = incomeAmount - expenseAmount;
  return monthlyCashFlow;
});
