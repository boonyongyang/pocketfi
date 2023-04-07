import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/budgets/application/budget_services.dart';
import 'package:pocketfi/src/features/category/application/category_services.dart';
import 'package:pocketfi/src/features/transactions/data/transaction_repository.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DetailBudgetOverview extends ConsumerWidget {
  const DetailBudgetOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBudget = ref.watch(selectedBudgetProvider);
    final userTransactions = ref.watch(userTransactionsProvider);

    final allTransaction = userTransactions.when<List<Transaction>>(
      data: (transactions) => transactions.where((tran) {
        return tran.date.year == DateTime.now().year &&
            tran.categoryName == selectedBudget!.categoryName;
      }).toList(),
      loading: () => [],
      error: (error, stackTrace) {
        debugPrint(error.toString());
        return [];
      },
    );
    final chartData = allTransaction
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
      final category =
          getCategoryWithCategoryName(transactions.first.categoryName);
      return CategoryChartData(
        x: DateFormat.MMM().format(DateTime(DateTime.now().year, date)),
        y: total * -1,
        color: category.color,
      );
    }).toList();

    for (var a in chartData) {
      debugPrint('x: ${a.x}, y: ${a.y}');
    }
    debugPrint('chartData: $chartData');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${selectedBudget!.categoryName} Overview'),
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
                offset: const Offset(3, 6), // changes position of shadow
              ),
            ],
          ),
          // height: MediaQuery.of(context).size.height * 0.5,
          child: SfCartesianChart(
            title: ChartTitle(
              text:
                  'Monthly Budget Overview for ${selectedBudget.categoryName}',
              textStyle: const TextStyle(
                // fontSize: 16,
                color: AppColors.mainColor1,
                // fontWeight: FontWeight.bold,
              ),
            ),
            plotAreaBorderWidth: 0,
            primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              labelFormat: '{value} MYR',
              // opposedPosition: true,
            ),
            series: <ChartSeries>[
              ColumnSeries<CategoryChartData, String>(
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),

                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  textStyle: TextStyle(
                    fontSize: 10,
                    color: AppColors.red,
                  ),
                ),
                dataLabelMapper: (CategoryChartData data, _) =>
                    'MYR ${data.y.toStringAsFixed(2)}',

                // dataLabelSettings: const DataLabelSettings(
                //   isVisible: true,
                //   labelPosition: ChartDataLabelPosition.outside,
                //   textStyle: TextStyle(
                //     fontSize: 14.0,
                //     fontWeight: FontWeight.bold,
                //     color: AppColors.mainColor1,
                //     fontFamily: 'Roboto',
                //   ),
                // ),
                // dataLabelMapper: (CategoryChartData trans, _) {
                //   final totalAmount = chartData.fold<double>(
                //     0.0,
                //     (previousValue, element) => previousValue + element.y,
                //   );

                //   return 'MYR $totalAmount';
                // },
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
