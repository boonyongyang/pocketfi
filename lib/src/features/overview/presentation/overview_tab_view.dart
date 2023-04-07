import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/authentication/presentation/login/divider_with_margins.dart';
import 'package:pocketfi/src/features/category/data/category_repository.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/overview/application/overview_services.dart';
import 'package:pocketfi/src/features/overview/presentation/category_list_tile.dart';
import 'package:pocketfi/src/features/overview/presentation/tag_list_tile.dart';
import 'package:pocketfi/src/features/tags/application/tag_services.dart';
import 'package:pocketfi/src/features/shared/date_picker/application/date_services.dart';
import 'package:pocketfi/src/features/transactions/data/transaction_repository.dart';
import 'package:pocketfi/src/features/transactions/presentation/add_new_transactions/select_transaction_type.dart';
import 'package:pocketfi/src/features/shared/date_picker/presentation/month_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OverviewTabView extends ConsumerWidget {
  const OverviewTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    // final transactionType = ref.watch(transactionTypeProvider);

    final currentMonthTransactions =
        ref.watch(currentMonthTransactionsProvider);

    final filteredCategories = ref.watch(filteredCategoriesProvider);
    final filteredTags = ref.watch(filteredTagsProvider);

    // if (currentMonthTransactions.isNotEmpty) {
    return RefreshIndicator(
      onRefresh: () {
        ref.refresh(overviewMonthProvider.notifier).resetMonth();
        ref.refresh(userTransactionsProvider);
        ref.refresh(filteredCategoriesProvider);
        ref.refresh(filteredTagsProvider);
        return Future.delayed(
          const Duration(milliseconds: 500),
        );
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20.0),
            const MonthPicker(),
            const SelectTransactionType(noOfTabs: 2),
            CategoryPieChart(filteredCategories: filteredCategories),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = filteredCategories[index];
                  return CategoryListTile(
                    categoryName: category.name,
                    icon: category.icon,
                    color: category.color,
                    // currentMonthTransactions: currentMonthTransactions,
                    // type: transactionType,
                  );
                },
              ),
            ),
            // const MonthlyCashFlowChart(),
            // const TagPieChart(),
            const DividerWithMargins(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    top: 24.0,
                    bottom: 8.0,
                  ),
                  child: Text('Tags',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainColor1,
                        fontFamily: 'Roboto',
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredTags.length,
                    itemBuilder: (context, index) {
                      // final category = filteredCategories[index];
                      final tag = filteredTags[index];
                      return TagListTile(
                        tagName: tag.name,
                        // icon: category.icon,
                        // color: category.color,
                        // currentMonthTransactions: currentMonthTransactions,
                        // type: type,
                      );
                    },
                  ),
                ),
              ],
            ),
            Visibility(
              visible: currentMonthTransactions.isEmpty,
              child: const EmptyContentsWithTextAnimationView(
                  text:
                      'Nothing to show here just yet. Add a transaction to get started.'),
            ),
            // * add 20% of screen height to make sure the bottom of the screen is not covered by the floating action button
            SizedBox(height: screenHeight * 0.2)
          ],
        ),
      ),
    );
  }
}

// view monthly cash flow chart, compare expenses and income percentage
class MonthlyCashFlowChart extends ConsumerWidget {
  const MonthlyCashFlowChart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;

    // FIXME: for 3 months, not working for now
    final cashFlow = ref.watch(monthlyCashFlowProvider);
    final now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;

    List<MonthlyCashFlow> monthlyCashFlows = [];
    for (var i = 0; i < 3; i++) {
      if (currentMonth == 1) {
        currentMonth = 12;
        currentYear--;
      } else {
        currentMonth--;
      }

      monthlyCashFlows.add(MonthlyCashFlow(
          month: '$currentMonth/$currentYear', amount: cashFlow));
    }

    // final currentMonth = DateTime.now().month;
    // final currentYear = DateTime.now().year;
    // final cashFlow = ref.watch(monthlyCashFlowProvider);

    // List<MonthlyCashFlow> monthlyCashFlows = [
    //   MonthlyCashFlow(month: '$currentMonth/$currentYear', amount: cashFlow),
    // ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
              child: ref.watch(currentMonthTransactionsProvider).isEmpty
                  ? const Text('No transactions found.')
                  : SfCartesianChart(
                      title: ChartTitle(text: 'Monthly Cash Flow'),
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        overflowMode: LegendItemOverflowMode.wrap,
                        textStyle: const TextStyle(fontSize: 14),
                      ),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      primaryXAxis: CategoryAxis(
                        majorGridLines: const MajorGridLines(width: 0),
                      ),
                      series: <ChartSeries>[
                        ColumnSeries<MonthlyCashFlow, String>(
                          color: AppColors.mainColor1,
                          dataSource: monthlyCashFlows,
                          xValueMapper: (MonthlyCashFlow cashFlow, _) =>
                              cashFlow.month,
                          yValueMapper: (MonthlyCashFlow cashFlow, _) =>
                              cashFlow.amount,
                          name: 'Cash Flow',
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelAlignment: ChartDataLabelAlignment.top,
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}

class MonthlyCashFlow {
  final String month;
  final double amount;

  MonthlyCashFlow({required this.month, required this.amount});
}

// view category pie chart, compare transactions by category
class CategoryPieChart extends ConsumerWidget {
  const CategoryPieChart({
    super.key,
    required this.filteredCategories,
  });

  final List<Category> filteredCategories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: 20.0,
            // top: 16.0,
            // bottom: 8.0,
          ),
          child: Text('Categories',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: AppColors.mainColor1,
                fontFamily: 'Roboto',
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                          title: ChartTitle(text: 'Transactions by Category'),
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
                                labelPosition: ChartDataLabelPosition.outside,
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
      ],
    );
  }
}

class TagPieChart extends ConsumerWidget {
  const TagPieChart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final allTags = ref.watch(userTagsNotifier);
    debugPrint('allTags: $allTags');
    final selectedTag = ref.watch(selectedTagProvider);
    debugPrint('selectedTag: $selectedTag');
    final transactions = ref.watch(currentMonthTransactionsProvider);
    debugPrint('transactions: ${transactions.length}');

    // final List<Transaction> transactionsWithSelectedTag = transactions
    //     .where((transaction) => transaction.tags.contains(selectedTag?.name))
    //     .toList();

    final Map<String, double> transactionsByTag = {};
    for (var transaction in transactions) {
      for (var tag in transaction.tags) {
        if (!transactionsByTag.containsKey(tag)) {
          transactionsByTag[tag] = 0;
        }
        transactionsByTag[tag] = transactionsByTag[tag]! + transaction.amount;
      }
    }

    final List<TagTransaction> transactionsWithSelectedTag = allTags
        .map((tag) {
          return TagTransaction(
            amount: transactionsByTag[tag.name] ?? 0,
            categoryName: tag.name,
            tags: [tag.name],
          );
        })
        .where((transaction) => transaction.amount > 0)
        .toList();

    // final List<Transaction> transactionsWithSelectedTag = transactions
    //     .where((transaction) =>
    //         allTags.any((tag) => transaction.tags.contains(tag.name)))
    //     .toList();
    // debugPrint(
    //     'transactionsWithSelectedTag: ${transactionsWithSelectedTag.length}');
    // final totalAmount = getTotalAmount(transactionsWithSelectedTag);
    // debugPrint('total Amount: $totalAmount');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: 20.0,
            top: 24.0,
            // bottom: 8.0,
          ),
          child: Text('Tags',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: AppColors.mainColor1,
                fontFamily: 'Roboto',
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                  child: transactionsWithSelectedTag.isEmpty
                      ? const Text('No transactions with selected tag found.')
                      : SfCircularChart(
                          title: ChartTitle(text: 'Transactions by Tag'),
                          legend: Legend(
                            isVisible: true,
                            position: LegendPosition.bottom,
                            overflowMode: LegendItemOverflowMode.wrap,
                            textStyle: const TextStyle(fontSize: 14),
                          ),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <DoughnutSeries<TagTransaction, String>>[
                            DoughnutSeries<TagTransaction, String>(
                              dataSource: transactionsWithSelectedTag,
                              // use colorList to set colors for each tag
                              pointColorMapper:
                                  (TagTransaction tagTransaction, _) {
                                final tag = allTags.firstWhere((tag) =>
                                    tagTransaction.tags.contains(tag.name));
                                return colorList[allTags.indexOf(tag)];
                              },
                              // pointColorMapper: (_, __) => Colors.blue,
                              dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                              ),
                              xValueMapper:
                                  (TagTransaction tagTransaction, _) =>
                                      tagTransaction.tags.first,
                              yValueMapper:
                                  (TagTransaction tagTransaction, _) =>
                                      tagTransaction.amount,
                            ),
                          ],
                        ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class TagTransaction {
  final double amount;
  final String categoryName;
  final List<String> tags;

  TagTransaction({
    required this.amount,
    required this.categoryName,
    required this.tags,
  });
}
