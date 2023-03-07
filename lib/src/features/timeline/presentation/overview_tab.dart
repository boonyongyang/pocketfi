import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/timeline/transactions/application/transaction_providers.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/add_new_transactions/select_transaction_type.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExpenseData {
  ExpenseData(this.category, this.percentage);

  final String category;
  final double percentage;
}

class OverviewTab extends ConsumerWidget {
  const OverviewTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<ExpenseData> expenseData = [
      ExpenseData('Food', 35),
      ExpenseData('Entertainment', 28),
      ExpenseData('Transportation', 34),
      ExpenseData('Home', 15),
      ExpenseData('Shopping', 32),
      ExpenseData('Others', 40)
    ];
    List<ExpenseData> incomeData = [
      ExpenseData('Salary', 35),
      ExpenseData('Selling', 28),
      ExpenseData('Others', 40)
    ];
    final List<ChartData> transactionsBarChartData = [
      const ChartData(category: 'Jan', income: 1000, expense: 500),
      const ChartData(category: 'Feb', income: 2000, expense: 1000),
      const ChartData(category: 'Mar', income: 3000, expense: 1500),
      const ChartData(category: 'Apr', income: 5000, expense: 2300),
      const ChartData(category: 'May', income: 4000, expense: 2100),
    ];
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SelectTransactionType(noOfTabs: 2),
            TransactionBarChart(
              data: transactionsBarChartData,
            ),
            ref.watch(transactionTypeProvider) == TransactionType.expense
                ? ExpenseChartTab(data: expenseData)
                : IncomeChartTab(data: incomeData),
          ],
        ),
      ),
    );
  }
}

class ExpenseChartTab extends StatelessWidget {
  const ExpenseChartTab({
    super.key,
    required this.data,
  });

  final List<ExpenseData> data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          // width: MediaQuery.of(context).size.width * 1.0,
          height: MediaQuery.of(context).size.height * 0.5,
          child: SfCircularChart(
            title: ChartTitle(text: 'Expenses by Category'),
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap,
              textStyle: const TextStyle(fontSize: 14),
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            // series: <CircularSeries<ExpenseData, String>>[
            series: <DoughnutSeries<ExpenseData, String>>[
              DoughnutSeries<ExpenseData, String>(
                dataSource: data,
                xValueMapper: (ExpenseData sales, _) => sales.category,
                yValueMapper: (ExpenseData sales, _) => sales.percentage,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.inside,
                  textStyle: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Roboto'),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(16.0),
              // color: Colors.grey,
              constraints: const BoxConstraints(),
              child: ListView.builder(
                // padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return CategoryListTile(
                    category: data[index].category,
                    percentage: data[index].percentage,
                  );
                },
              ),
            ),
            // }).toList()
          ],
        ),
      ],
    );
  }
}

class IncomeChartTab extends StatelessWidget {
  const IncomeChartTab({
    super.key,
    required this.data,
  });

  final List<ExpenseData> data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          // width: MediaQuery.of(context).size.width * 1.0,
          height: MediaQuery.of(context).size.height * 0.5,
          child: SfCircularChart(
            title: ChartTitle(text: 'Incomes by Category'),
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap,
              textStyle: const TextStyle(fontSize: 14),
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            // series: <CircularSeries<ExpenseData, String>>[
            series: <DoughnutSeries<ExpenseData, String>>[
              DoughnutSeries<ExpenseData, String>(
                dataSource: data,
                xValueMapper: (ExpenseData sales, _) => sales.category,
                yValueMapper: (ExpenseData sales, _) => sales.percentage,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.inside,
                  textStyle: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Roboto'),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(16.0),
              // color: Colors.grey,
              constraints: const BoxConstraints(),
              child: ListView.builder(
                // padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return CategoryListTile(
                    category: data[index].category,
                    percentage: data[index].percentage,
                  );
                },
              ),
            ),
            // }).toList()
          ],
        ),
      ],
    );
  }
}

class CategoryListTile extends StatelessWidget {
  const CategoryListTile({
    super.key,
    required this.category,
    required this.percentage,
  });

  final double percentage;
  final String category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // navigate to category details
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const CircleAvatar(
              child: Icon(
                Icons.home,
                color: Colors.amber,
                size: 24,
              ),
            ),
            const SizedBox(
              width: 12.0,
              // height: 10.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(fontSize: 16),
                ),
                const Text(
                  '5 transactions',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              percentage.toString(),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionBarChart extends StatelessWidget {
  final List<ChartData> data;

  const TransactionBarChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[
          ColumnSeries<ChartData, String>(
            name: 'Income',
            dataSource: data,
            xValueMapper: (ChartData sales, _) => sales.category,
            yValueMapper: (ChartData sales, _) => sales.income,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            borderRadius: BorderRadius.circular(10),
            color: Colors.green,
          ),
          ColumnSeries<ChartData, String>(
            name: 'Expenses',
            dataSource: data,
            xValueMapper: (ChartData sales, _) => sales.category,
            yValueMapper: (ChartData sales, _) => sales.expense,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            borderRadius: BorderRadius.circular(10),
            color: Colors.red,
          ),
          LineSeries<ChartData, String>(
            name: 'Trend',
            dataSource: data,
            xValueMapper: (ChartData sales, _) => sales.category,
            yValueMapper: (ChartData sales, _) => sales.income - sales.expense,
            color: Colors.blue,
          )
        ],
      ),
    );
  }
}

class ChartData {
  final String category;
  final double income;
  final double expense;

  const ChartData({
    required this.category,
    required this.income,
    required this.expense,
  });
}
