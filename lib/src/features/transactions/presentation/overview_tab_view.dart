import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/category/application/category_services.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/overview/presentation/category_detail_page.dart';
import 'package:pocketfi/src/features/transactions/application/transaction_services.dart';
import 'package:pocketfi/src/features/transactions/data/transaction_repository.dart';
import 'package:pocketfi/src/features/transactions/date_picker/application/transaction_date_services.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/transactions/presentation/add_new_transactions/select_transaction_type.dart';
import 'package:pocketfi/src/features/transactions/presentation/overview/overview_month_selector.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OverviewTabView extends ConsumerWidget {
  const OverviewTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionType = ref.watch(transactionTypeProvider);
    final userTransactions = ref.watch(userTransactionsProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    // final month = DateTime.now();
    final month = ref.watch(overviewMonthProvider);

    List<Category> categoriesList = transactionType == TransactionType.expense
        ? ref.watch(expenseCategoriesProvider)
        : ref.watch(incomeCategoriesProvider);

    // final filteredCategories = categoriesList.where(
    //   (category) => userTransactions.when(
    //     data: (transactions) => transactions.any(
    //       (tran) => tran.categoryName == category.name,
    //     ),
    //     loading: () => false,
    //     error: (error, stackTrace) {
    //       debugPrint(error.toString());
    //       return false;
    //     },
    //   ),
    // );

    // final filteredCategories = categoriesList.where((category) {
    //   debugPrint(
    //       'date of transaction is ${currentMonthTransactions.first.date}');
    //   return currentMonthTransactions.any((tran) {
    //     return tran.categoryName == category.name;
    //   });
    // }).toList();

    // double getCategoryTotalAmountForCurrentMonth(
    //     String categoryName, List<Transaction> transactions) {
    //   final categoryTransactions = transactions.where((tran) {
    //     return tran.categoryName == categoryName &&
    //         tran.date.month == now.month &&
    //         tran.date.year == now.year;
    //   }).toList();
    //   return getTotalAmount(categoryTransactions);
    // }

    // final currentMonthTransactions = userTransactions.when(
    //   data: (transactions) => transactions.where((tran) {
    //     return tran.date.month == now.month && tran.date.year == now.year;
    //   }).toList(), // Add explicit cast here
    //   loading: () => [] as List<Transaction>, // Add explicit cast here
    //   error: (error, stackTrace) {
    //     debugPrint(error.toString());
    //     return [] as List<Transaction>; // Add explicit cast here
    //   },
    // );

    final currentMonthTransactions = userTransactions.when<List<Transaction>>(
      data: (transactions) => transactions.where((tran) {
        // if data is empty, then the where function will return an empty list
        return tran.date.month == month.month && tran.date.year == month.year;
      }).toList(),
      loading: () => [],
      error: (error, stackTrace) {
        debugPrint(error.toString());
        return [];
      },
    );

    // final currentMonthTransactions = userTransactions.when(
    //   data: (transactions) {
    //     if (transactions is List<Transaction>) {
    //       return transactions.where((tran) {
    //         return tran.date.month == now.month && tran.date.year == now.year;
    //       }).toList();
    //     } else {
    //       return [];
    //     }
    //   },
    //   loading: () => [] as List<Transaction>,
    //   error: (error, stackTrace) {
    //     debugPrint(error.toString());
    //     return [] as List<Transaction>;
    //   },
    // );

    // A function to calculate the total amount for a category in the current month
    double getCategoryTotalAmountForCurrentMonth(
        String categoryName, List<Transaction> transactions) {
      final categoryTransactions =
          transactions.where((tran) => tran.categoryName == categoryName);
      return getTotalAmount(categoryTransactions.toList());
    }

    final filteredCategories = categoriesList.where((category) {
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
            // create a month selector, and whenever the month is changed, the chart should be updated
            OverviewMonthSelector(
              onMonthChanged: (DateTime date) {
                ref.read(overviewMonthProvider.notifier).setMonth(date);
              },
            ),
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
                                    // return userTransactions.when(
                                    //   data: (transactions) {
                                    //     final categoryTransactions = transactions.where(
                                    //         (tran) => tran.categoryName == category.name);
                                    //     final totalAmount =
                                    //         getTotalAmount(categoryTransactions.toList());
                                    //     return totalAmount;
                                    //   },
                                    //   loading: () => 0,
                                    //   error: (error, stackTrace) {
                                    //     debugPrint(error.toString());
                                    //     return 0;
                                    //   },
                                    // );
                                    return getCategoryTotalAmountForCurrentMonth(
                                      category.name,
                                      currentMonthTransactions,
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
                                    final totalAmount = (() {
                                      switch (transactionType) {
                                        case TransactionType.expense:
                                        case TransactionType.income:
                                        case TransactionType.transfer:
                                          final type = transactionType;
                                          final transactionsOfType =
                                              currentMonthTransactions
                                                  .where((tran) =>
                                                      tran.type == type)
                                                  .toList();
                                          final totalAmountOfType =
                                              getTotalAmount(
                                                  transactionsOfType);
                                          return totalAmountOfType;
                                      }
                                    })();
                                    final categoryTotalAmount =
                                        getCategoryTotalAmountForCurrentMonth(
                                            category.name,
                                            currentMonthTransactions);
                                    final percentage = totalAmount > 0
                                        ? (categoryTotalAmount /
                                                totalAmount *
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
                height: screenHeight * 0.7,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = filteredCategories[index];
                    return CategoryListTile(
                      categoryName: category.name,
                      icon: category.icon,
                      color: category.color,
                      currentMonthTransactions: currentMonthTransactions,
                      type: transactionType,
                    );
                  },
                ),
              ),
            ),
            // SizedBox(
            //   height: screenHeight * 0.9,
            //   child: userTransactions.when(
            //     data: (transactions) {
            //       final categories = ref.watch(categoriesProvider);
            //       final filteredCategories = categories
            //           .where(
            //             (category) => transactions.any(
            //               (tran) => tran.categoryName == category.name,
            //             ),
            //           )
            //           .toList();
            //       filteredCategories.sort((a, b) {
            //         final aTransactions = transactions
            //             .where((tran) => tran.categoryName == a.name)
            //             .toList();
            //         final bTransactions = transactions
            //             .where((tran) => tran.categoryName == b.name)
            //             .toList();
            //         final aTotalAmount = getTotalAmount(aTransactions);
            //         final bTotalAmount = getTotalAmount(bTransactions);
            //         return bTotalAmount.compareTo(aTotalAmount);
            //       });
            //       // return ListView.builder(
            //       //   physics: const NeverScrollableScrollPhysics(),
            //       //   itemCount: filteredCategories.length,
            //       //   itemBuilder: (context, index) {
            //       //     final category = filteredCategories[index];
            //       //     final categoryTransactions = transactions
            //       //         .where((tran) => tran.categoryName == category.name)
            //       //         .toList();
            //       //     final totalAmount = getTotalAmount(categoryTransactions);
            //       //     final numTransactions = categoryTransactions.length;
            //       //     final percentage =
            //       //         totalAmount / getTotalAmount(transactions.toList());
            //       //     return CategoryListTile(
            //       //       category: category.name,
            //       //       icon: category.icon,
            //       //       totalAmount: totalAmount,
            //       //       color: category.color,
            //       //       numTransactions: numTransactions,
            //       //       percentage: percentage.toStringAsFixed(2),
            //       //     );
            //       //   },
            //       // );
            //       return ListView.builder(
            //         physics: const NeverScrollableScrollPhysics(),
            //         itemCount: filteredCategories.length,
            //         itemBuilder: (context, index) {
            //           final category = filteredCategories[index];
            //           return CategoryListTile(
            //             category: category.name,
            //             icon: category.icon,
            //             color: category.color,
            //             currentMonthTransactions: currentMonthTransactions,
            //           );
            //         },
            //       );
            //     },
            //     loading: () => const Center(
            //       child: CircularProgressIndicator(),
            //     ),
            //     error: (error, stackTrace) {
            //       debugPrint(error.toString());
            //       return const Center(
            //         child: Text('Error'),
            //       );
            //     },
            //   ),
            // ),
            SizedBox(height: screenHeight * 0.3)
          ],
        ),
      ),
    );
  }

  double getTotalAmount(List<Transaction> transactions) {
    return transactions.fold<double>(
      0,
      (previousValue, element) => previousValue + element.amount,
    );
  }

  // double getTotalAmountOfAllTransactions(List<Transaction> transactions) {
  //   return transactions.fold(0, (sum, transaction) => sum + transaction.amount);
  // }
}

// class CategoryListTile extends StatelessWidget {
//   const CategoryListTile({
//     super.key,
//     required this.category,
//     required this.totalAmount,
//     required this.icon,
//     required this.color,
//     required this.numTransactions,
//     required this.percentage,
//   });

//   final String percentage;
//   final String category;
//   final double totalAmount;
//   final Icon icon;
//   final Color color;
//   final int numTransactions;

//   @override
//   Widget build(BuildContext context) {
//     final amountStr = '-MYR ${totalAmount.toStringAsFixed(2)}';
//     return GestureDetector(
//       onTap: () {
//         // navigate to category details
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             CircleAvatar(
//               backgroundColor: color,
//               child: icon,
//             ),
//             const SizedBox(width: 12.0),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   category,
//                   style: const TextStyle(fontSize: 16),
//                 ),
//                 Text(
//                   '$numTransactions transactions',
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//             const Spacer(),
//             Text(
//               // percentage.toString(),
//               amountStr,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w400,
//                 color: Colors.red,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class CategoryListTile extends StatelessWidget {
  const CategoryListTile({
    Key? key,
    required this.categoryName,
    required this.icon,
    required this.color,
    required this.currentMonthTransactions,
    required this.type,
  }) : super(key: key);

  final String categoryName;
  final Icon icon;
  final Color color;
  final List<Transaction> currentMonthTransactions;
  final TransactionType type;

  @override
  Widget build(BuildContext context) {
    // final categoryTransactions = currentMonthTransactions
    //     .where((tran) => tran.categoryName == category)
    //     .toList();
    // final numTransactions = categoryTransactions.length;
    // final totalAmount = getTotalAmount(categoryTransactions);
    // final totalAmountAllCategories = getTotalAmount(currentMonthTransactions);
    // final percentage = totalAmountAllCategories > 0
    //     ? totalAmount / totalAmountAllCategories
    //     : 0.0;
    // final percentageStr = '${(percentage * 100).toStringAsFixed(1)}%';
    // final amountStr = '-MYR ${totalAmount.toStringAsFixed(2)}';

    final transactionsOfType =
        currentMonthTransactions.where((tran) => tran.type == type).toList();

    final totalAmountOfType = getTotalAmount(transactionsOfType);

    final categoryTransactions = transactionsOfType
        .where((tran) => tran.categoryName == categoryName)
        .toList();

    final numTransactions = categoryTransactions.length;

    final categoryTotalAmount = getTotalAmount(categoryTransactions);

    final percentageStr = totalAmountOfType > 0
        ? (categoryTotalAmount / totalAmountOfType * 100).toStringAsFixed(1)
        : '0.0';

    final amountStr = 'MYR ${categoryTotalAmount.toStringAsFixed(2)}';

    return GestureDetector(
      onTap: () {
        // navigate to category details
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                CategoryDetailPage(categoryName: categoryName),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: icon,
            ),
            const SizedBox(width: 12.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoryName,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  // if numTransactions is more than 1 then plural
                  numTransactions > 1
                      ? '$numTransactions transactions'
                      : '$numTransactions transaction',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              '$percentageStr%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: type.color,
              ),
            ),
            const SizedBox(width: 12.0),
            Text(
              type.symbol + amountStr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: type.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double getTotalAmount(List<Transaction> transactions) {
    return transactions.fold<double>(
      0,
      (previousValue, element) => previousValue + element.amount,
    );
  }
}
