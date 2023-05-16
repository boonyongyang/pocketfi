import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/budgets/data/budget_repository.dart';
import 'package:pocketfi/src/features/transactions/data/transaction_repository.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BudgetOverview extends ConsumerWidget {
  const BudgetOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(userBudgetsProvider);
    final userTransactions = ref.watch(userTransactionsProvider);

    final budgetss = budgets.value;

    if (budgetss == null) return Container();

    final transactionsWithBudgets = userTransactions.when<List<Transaction>>(
      data: (transactions) {
        final budgetCategoryNames =
            budgets.value!.map((budget) => budget.categoryName).toList();
        final budgetWalletId =
            budgets.value!.map((budget) => budget.walletId).toList();
        final filteredTransactions = transactions.where((tran) {
          return budgetCategoryNames.contains(tran.categoryName) &&
              budgetWalletId.contains(tran.walletId);
        }).toList();

        return filteredTransactions;
      },
      loading: () => [],
      error: (error, stackTrace) {
        debugPrint(error.toString());
        return [];
      },
    );
    final chartData = transactionsWithBudgets
        .groupListsBy((tran) => tran.date.month)
        .entries
        .toList()
        .reversed
        .map((entry) {
      final date = entry.key;
      final transactions = entry.value;
      final total = transactions.fold<double>(
        0.0,
        (previousValue, transaction) {
          if (transaction.type == TransactionType.expense) {
            return previousValue - transaction.amount;
          } else {
            return previousValue;
          }
        },
      );
      return CategoryChartData(
        x: DateFormat.MMM().format(DateTime(DateTime.now().year, date)),
        y: total * -1,
        color: AppColors.mainColor2,
      );
    }).toList();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Budget Overview'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(3, 6),
              ),
            ],
          ),
          child: SfCartesianChart(
            title: ChartTitle(
              text: 'Monthly Budget Overview',
              textStyle: const TextStyle(
                color: AppColors.mainColor1,
              ),
            ),
            plotAreaBorderWidth: 0,
            primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              labelFormat: '{value} MYR',
            ),
            series: <ChartSeries>[
              LineSeries<CategoryChartData, String>(
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  textStyle: TextStyle(
                    fontSize: 10,
                    color: AppColors.red,
                  ),
                ),
                dataLabelMapper: (CategoryChartData data, _) =>
                    'MYR ${data.y.toStringAsFixed(2)}',
                dataSource: chartData,
                xValueMapper: (CategoryChartData data, _) => data.x,
                yValueMapper: (CategoryChartData data, _) => data.y,
                pointColorMapper: (CategoryChartData data, _) => data.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryChartData {
  final String x;
  final double y;
  final Color color;

  CategoryChartData({
    required this.x,
    required this.y,
    required this.color,
  });
}
