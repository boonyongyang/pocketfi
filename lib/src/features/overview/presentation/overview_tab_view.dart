import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/overview/application/overview_services.dart';
import 'package:pocketfi/src/features/overview/presentation/category_list_tile.dart';
import 'package:pocketfi/src/features/transactions/application/transaction_services.dart';
import 'package:pocketfi/src/features/transactions/date_picker/application/transaction_date_services.dart';
import 'package:pocketfi/src/features/transactions/presentation/add_new_transactions/select_transaction_type.dart';
import 'package:pocketfi/src/features/overview/presentation/overview_month_selector.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OverviewTabView extends ConsumerWidget {
  const OverviewTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionType = ref.watch(transactionTypeProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    final currentMonthTransactions =
        ref.watch(currentMonthTransactionsProvider);

    final filteredCategories = ref.watch(filteredCategoriesProvider);

    return RefreshIndicator(
      onRefresh: () {
        ref.refresh(overviewMonthProvider.notifier).resetMonth();
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
            const SelectTransactionType(noOfTabs: 2),
            const SizedBox(height: 10.0),
            const OverviewMonthSelector(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Container(
                    height: screenHeight * 0.4,
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
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: filteredCategories.isEmpty
                          ? const Text('No transactions found.')
                          : SfCircularChart(
                              title:
                                  ChartTitle(text: 'Transactions by Category'),
                              legend: Legend(
                                isVisible: true,
                                position: LegendPosition.bottom,
                                overflowMode: LegendItemOverflowMode.wrap,
                                textStyle: const TextStyle(fontSize: 14),
                              ),
                              tooltipBehavior: TooltipBehavior(enable: true),
                              series: <DoughnutSeries<Category, String>>[
                                DoughnutSeries<Category, String>(
                                  dataSource: filteredCategories.toList(),
                                  xValueMapper: (Category category, _) =>
                                      category.name,
                                  yValueMapper: (Category category, _) {
                                    return ref.read(
                                      categoryTotalAmountForCurrentMonthProvider(
                                        category.name,
                                      ),
                                    );
                                  },
                                  pointColorMapper: (Category category, _) =>
                                      category.color,
                                  dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                    labelPosition:
                                        ChartDataLabelPosition.outside,
                                    textStyle: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.mainColor1,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  dataLabelMapper: (Category category, _) {
                                    final totalTypeAmount =
                                        ref.watch(totalTypeAmountProvider);

                                    final categoryTotalAmount = ref.read(
                                      categoryTotalAmountForCurrentMonthProvider(
                                        category.name,
                                      ),
                                    );

                                    final percentage = totalTypeAmount > 0
                                        ? (categoryTotalAmount /
                                                totalTypeAmount *
                                                100)
                                            .toStringAsFixed(1)
                                        : '0.0';
                                    return '$percentage%';
                                  },
                                  pointRenderMode: PointRenderMode.segment,
                                  enableTooltip: true,
                                  emptyPointSettings: EmptyPointSettings(
                                    mode: EmptyPointMode.gap,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: screenHeight * 0.5,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = filteredCategories[index];
                    return Expanded(
                      child: CategoryListTile(
                        categoryName: category.name,
                        icon: category.icon,
                        color: category.color,
                        currentMonthTransactions: currentMonthTransactions,
                        type: transactionType,
                      ),
                    );
                  },
                ),
              ),
            ),
            // SizedBox(height: screenHeight * 0.3)
          ],
        ),
      ),
    );
  }
}
