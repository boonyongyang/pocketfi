import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/transactions/application/transaction_services.dart';
import 'package:pocketfi/src/features/transactions/data/transaction_repository.dart';
import 'package:pocketfi/src/features/shared/date_picker/application/date_services.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/shared/date_picker/presentation/month_picker.dart';
import 'package:pocketfi/src/features/transactions/presentation/transactions_list_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TagDetailPage extends ConsumerWidget {
  final String tagName;

  const TagDetailPage({
    Key? key,
    required this.tagName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userTransactions = ref.watch(userTransactionsProvider);
    final type = ref.watch(transactionTypeProvider);
    final currentMonthTransactions = userTransactions.when<List<Transaction>>(
      data: (transactions) => transactions.where((tran) {
        return tran.date.month == ref.watch(overviewMonthProvider).month &&
            tran.date.year == ref.watch(overviewMonthProvider).year &&
            tran.type == type &&
            tran.tags.contains(tagName);
      }).toList(),
      loading: () => [],
      error: (error, stackTrace) {
        debugPrint(error.toString());
        return [];
      },
    );
    final totalAmount = getTagTotalAmount(currentMonthTransactions);
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
      return TagChartData(
        x: day.toString(),
        y: total,
        color: AppColors.mainColor2,
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(tagName),
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
                  color: AppColors.mainColor2,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8.0),
              const MonthPicker(),
              const SizedBox(height: 10),
              currentMonthTransactions.isEmpty
                  ? const SizedBox(
                      child: EmptyContentsWithTextAnimationView(
                        text: Strings.youHaveNoRecords,
                      ),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis: NumericAxis(
                          labelFormat: '{value} MYR',
                        ),
                        series: <ChartSeries>[
                          ColumnSeries<TagChartData, String>(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                            dataSource: chartData,
                            xValueMapper: (TagChartData data, _) => data.x,
                            yValueMapper: (TagChartData data, _) => data.y,
                            pointColorMapper: (TagChartData data, _) =>
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

  double getTagTotalAmount(List<Transaction> transactions) {
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

class TagChartData {
  final String x;
  final double y;
  final Color color;

  TagChartData({
    required this.x,
    required this.y,
    required this.color,
  });
}
