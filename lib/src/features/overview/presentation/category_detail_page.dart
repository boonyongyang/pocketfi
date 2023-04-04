import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/category/application/category_services.dart';
import 'package:pocketfi/src/features/transactions/data/transaction_repository.dart';
import 'package:pocketfi/src/features/transactions/date_picker/application/transaction_date_services.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/overview/presentation/overview_month_selector.dart';
import 'package:pocketfi/src/features/transactions/presentation/transactions_list_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CategoryDetailPage extends ConsumerWidget {
  final String categoryName;

  const CategoryDetailPage({
    Key? key,
    required this.categoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userTransactions = ref.watch(userTransactionsProvider);

    final currentMonthTransactions = userTransactions.when<List<Transaction>>(
      data: (transactions) => transactions.where((tran) {
        return tran.date.month == ref.watch(overviewMonthProvider).month &&
            tran.date.year == ref.watch(overviewMonthProvider).year &&
            tran.categoryName == categoryName;
      }).toList(),
      loading: () => [],
      error: (error, stackTrace) {
        debugPrint(error.toString());
        return [];
      },
    );
    final totalAmount = getCategoryTotalAmount(currentMonthTransactions);

    // prepare chart data
    final chartData = currentMonthTransactions
        .groupListsBy((tran) => tran.date.day)
        .entries
        .map((entry) {
      final day = entry.key;
      final transactions = entry.value;
      final total = transactions.fold<double>(
        0.0,
        (previousValue, transaction) {
          if (transaction.type == TransactionType.expense) {
            return previousValue - transaction.amount;
          } else if (transaction.type == TransactionType.income) {
            return previousValue + transaction.amount;
          } else {
            return previousValue;
          }
        },
      );
      final category =
          getCategoryWithCategoryName(transactions.first.categoryName);
      return CategoryChartData(
        x: day.toString(),
        y: total,
        color: category.color,
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(categoryName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          ref.refresh(userTransactionsProvider);
          return Future.delayed(
            const Duration(
              milliseconds: 500,
            ),
          );
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8.0),
              Text(
                'Total: MYR${totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8.0),
              const OverviewMonthSelector(),
              const SizedBox(height: 10),
              currentMonthTransactions.isEmpty
                  ? const SizedBox(
                      // color: Colors.grey,
                      child: EmptyContentsWithTextAnimationView(
                        text: Strings.youHaveNoRecords,
                      ),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: SfCartesianChart(
                        // legend: Legend(isVisible: false),
                        // title: ChartTitle(text: 'Monthly expense'),
                        plotAreaBorderWidth: 0,
                        primaryXAxis: CategoryAxis(
                            // majorGridLines: null,
                            // minorGridLines: null,
                            ),
                        primaryYAxis: NumericAxis(
                          // majorGridLines: null,
                          // minorGridLines: null,
                          labelFormat: '{value} MYR',
                        ),
                        series: <ChartSeries>[
                          ColumnSeries<CategoryChartData, String>(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                            dataSource: chartData,
                            xValueMapper: (CategoryChartData data, _) => data.x,
                            yValueMapper: (CategoryChartData data, _) => data.y,
                            pointColorMapper: (CategoryChartData data, _) =>
                                data.color,
                          ),
                        ],
                      ),
                    ),
              const SizedBox(height: 10),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: TransactionListView(
                  transactions: currentMonthTransactions,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double getCategoryTotalAmount(List<Transaction> transactions) {
    return transactions.fold<double>(
      0.0,
      (previousValue, transaction) {
        if (transaction.type == TransactionType.expense) {
          return previousValue - transaction.amount;
        } else if (transaction.type == TransactionType.income) {
          return previousValue + transaction.amount;
        } else {
          return previousValue;
        }
      },
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
