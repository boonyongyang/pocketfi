import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/category/application/category_services.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/transactions/application/transaction_services.dart';
import 'package:pocketfi/src/features/transactions/data/transaction_repository.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/transactions/presentation/add_new_transactions/select_transaction_type.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OverviewTabView extends ConsumerWidget {
  const OverviewTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final categories = ref.watch(categoriesProvider);
    final transactionType = ref.watch(transactionTypeProvider);
    final userTransactions = ref.watch(userTransactionsProvider);
    // final amount = 0.0;

    // Declare a GlobalKey variable to create a reference to the widget
    // final GlobalKey dataLabelKey = GlobalKey();
    final screenHeight = MediaQuery.of(context).size.height;

    List<Category> categoriesList = transactionType == TransactionType.expense
        ? ref.watch(expenseCategoriesProvider)
        : ref.watch(incomeCategoriesProvider);

    final filteredCategories = categoriesList.where(
      (category) => userTransactions.when(
        data: (transactions) => transactions.any(
          (tran) => tran.categoryName == category.name,
        ),
        loading: () => false,
        error: (error, stackTrace) {
          debugPrint(error.toString());
          return false;
        },
      ),
    );

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SelectTransactionType(noOfTabs: 2),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
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
                // child: SfCircularChart(
                //   title: ChartTitle(text: 'Transactions by Category'),
                //   legend: Legend(
                //     isVisible: true,
                //     position: LegendPosition.bottom,
                //     overflowMode: LegendItemOverflowMode.wrap,
                //     textStyle: const TextStyle(fontSize: 14),
                //   ),
                //   tooltipBehavior: TooltipBehavior(enable: true),
                //   series: <DoughnutSeries<Category, String>>[
                //     DoughnutSeries<Category, String>(
                //       dataSource: filteredCategories.toList(),
                //       // dataSource: categoriesList,
                //       xValueMapper: (Category category, _) => category.name,
                //       yValueMapper: (Category category, _) {
                //         return userTransactions.when(
                //           data: (transactions) {
                //             final categoryTransactions = transactions.where(
                //                 (tran) => tran.categoryName == category.name);
                //             final totalAmount =
                //                 getTotalAmount(categoryTransactions.toList());
                //             return totalAmount;
                //           },
                //           loading: () => 0,
                //           error: (error, stackTrace) {
                //             debugPrint(error.toString());
                //             return 0;
                //           },
                //         );
                //       },
                //       pointColorMapper: (Category category, _) =>
                //           category.color,
                //       dataLabelSettings: const DataLabelSettings(
                //         isVisible: true,
                //         labelPosition: ChartDataLabelPosition.outside,
                //         textStyle: TextStyle(
                //           fontSize: 14.0,
                //           fontWeight: FontWeight.bold,
                //           color: AppColors.mainColor1,
                //           fontFamily: 'Roboto',
                //         ),
                //       ),
                //       dataLabelMapper: (Category category, _) {
                //         final totalAmount = userTransactions.when(
                //           data: (transactions) {
                //             final categoryTransactions = transactions.where(
                //                 (tran) => tran.categoryName == category.name);
                //             if (categoryTransactions.isEmpty) {
                //               return null;
                //             }
                //             final categoryTotalAmount =
                //                 getTotalAmount(categoryTransactions.toList());
                //             final totalAmount =
                //                 getTotalAmount(transactions.toList());
                //             final percentage = totalAmount > 0
                //                 ? (categoryTotalAmount / totalAmount * 100)
                //                     .toStringAsFixed(1)
                //                 : '0.0';
                //             return '$percentage%';
                //             // return '${category.name}: $percentage%';
                //           },
                //           loading: () => null,
                //           error: (error, stackTrace) {
                //             debugPrint(error.toString());
                //             return null;
                //           },
                //         );
                //         return totalAmount;
                //       },
                //       pointRenderMode: PointRenderMode.segment,
                //       enableTooltip: true,
                //       emptyPointSettings: EmptyPointSettings(
                //         mode: EmptyPointMode.gap,
                //       ),
                //     ),
                //   ],
                // ),
                child: SfCircularChart(
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
                      xValueMapper: (Category category, _) => category.name,
                      yValueMapper: (Category category, _) {
                        return userTransactions.when(
                          data: (transactions) {
                            final categoryTransactions = transactions.where(
                                (tran) => tran.categoryName == category.name);
                            final totalAmount =
                                getTotalAmount(categoryTransactions.toList());
                            return totalAmount;
                          },
                          loading: () => 0,
                          error: (error, stackTrace) {
                            debugPrint(error.toString());
                            return 0;
                          },
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
                        final totalAmount = userTransactions.when(
                          data: (transactions) {
                            final categoryTransactions = transactions.where(
                                (tran) => tran.categoryName == category.name);
                            if (categoryTransactions.isEmpty) {
                              return null;
                            }
                            final categoryTotalAmount =
                                getTotalAmount(categoryTransactions.toList());
                            final totalAmount = (() {
                              switch (transactionType) {
                                case TransactionType.expense:
                                case TransactionType.income:
                                case TransactionType.transfer:
                                  final type = transactionType;
                                  final transactionsOfType = transactions
                                      .where((tran) => tran.type == type)
                                      .toList();
                                  final totalAmountOfType =
                                      getTotalAmount(transactionsOfType);
                                  return totalAmountOfType;
                              }
                            })();
                            final percentage = totalAmount > 0
                                ? (categoryTotalAmount / totalAmount * 100)
                                    .toStringAsFixed(1)
                                : '0.0';
                            return '$percentage%';
                          },
                          loading: () => null,
                          error: (error, stackTrace) {
                            debugPrint(error.toString());
                            return null;
                          },
                        );
                        return totalAmount;
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
            ),
          ),
          SizedBox(
            height: screenHeight * 0.9,
            child: userTransactions.when(
              data: (transactions) {
                final categories = ref.watch(categoriesProvider);
                final filteredCategories = categories
                    .where(
                      (category) => transactions.any(
                        (tran) => tran.categoryName == category.name,
                      ),
                    )
                    .toList();
                filteredCategories.sort((a, b) {
                  final aTransactions = transactions
                      .where((tran) => tran.categoryName == a.name)
                      .toList();
                  final bTransactions = transactions
                      .where((tran) => tran.categoryName == b.name)
                      .toList();
                  final aTotalAmount = getTotalAmount(aTransactions);
                  final bTotalAmount = getTotalAmount(bTransactions);
                  return bTotalAmount.compareTo(aTotalAmount);
                });
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = filteredCategories[index];
                    final categoryTransactions = transactions
                        .where((tran) => tran.categoryName == category.name)
                        .toList();
                    final totalAmount = getTotalAmount(categoryTransactions);
                    final numTransactions = categoryTransactions.length;
                    final percentage =
                        totalAmount / getTotalAmount(transactions.toList());
                    return CategoryListTile(
                      category: category.name,
                      icon: category.icon,
                      totalAmount: totalAmount,
                      color: category.color,
                      numTransactions: numTransactions,
                      percentage: percentage.toStringAsFixed(2),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) {
                debugPrint(error.toString());
                return const Center(
                  child: Text('Error'),
                );
              },
            ),
          ),
          SizedBox(
            height: screenHeight * 0.3,
          )
        ],
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

class CategoryListTile extends StatelessWidget {
  const CategoryListTile({
    super.key,
    required this.category,
    required this.totalAmount,
    required this.icon,
    required this.color,
    required this.numTransactions,
    required this.percentage,
  });

  final String percentage;
  final String category;
  final double totalAmount;
  final Icon icon;
  final Color color;
  final int numTransactions;

  @override
  Widget build(BuildContext context) {
    final amountStr = '-MYR ${totalAmount.toStringAsFixed(2)}';
    return GestureDetector(
      onTap: () {
        // navigate to category details
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  '$numTransactions transactions',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              // percentage.toString(),
              amountStr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// dataLabelMapper: (Category category, _) {
//   final totalAmount = userTransactions.when(
//     data: (transactions) {
//       final categoryTransactions = transactions.where(
//           (tran) => tran.categoryName == category.name);
//       if (categoryTransactions.isEmpty) {
//         return null;
//       }
//       final categoryTotalAmount =
//           getTotalAmount(categoryTransactions.toList());
//       final totalAmount =
//           getTotalAmount(transactions.toList());
//       final percentage = totalAmount > 0
//           ? (categoryTotalAmount / totalAmount * 100)
//               .toStringAsFixed(2)
//           : '0.00';
//       return '$percentage%';
//     },
//     loading: () => null,
//     error: (error, stackTrace) {
//       debugPrint(error.toString());
//       return null;
//     },
//   );
//   return totalAmount;
// },

// dataLabelMapper: (Category category, _) {
//   final totalAmount = userTransactions.when(
//     data: (transactions) {
//       final categoryTransactions = transactions.where(
//           (tran) => tran.categoryName == category.name);
//       final categoryTotalAmount =
//           getTotalAmount(categoryTransactions.toList());
//       final totalAmount =
//           getTotalAmount(transactions.toList());
//       final percentage = totalAmount > 0
//           ? (categoryTotalAmount / totalAmount * 100)
//               .toStringAsFixed(2)
//           : '0.00';
//       return '$percentage%';
//     },
//     loading: () => '',
//     error: (error, stackTrace) {
//       debugPrint(error.toString());
//       return '';
//     },
//   );
//   return totalAmount;
// },

// dataLabelMapper: (Category category, _) {
//   final totalAmount = userTransactions.when(
//     data: (transactions) {
//       final categoryTransactions = transactions.where(
//           (tran) => tran.categoryName == category.name);
//       final totalAmount =
//           getTotalAmount(categoryTransactions.toList());
//       return totalAmount;
//     },
//     loading: () => 0,
//     error: (error, stackTrace) {
//       debugPrint(error.toString());
//       return 0;
//     },
//   );
//   return totalAmount > 0
//       ? '\$${totalAmount.toStringAsFixed(2)}'
//       : '';
// },
// dataLabelMapper: (Category category, _) {
//   return userTransactions.when(
//     data: (transactions) {
//       final categoryTransactions = transactions.where(
//           (tran) => tran.categoryName == category.name);
//       final totalAmount =
//           getTotalAmount(categoryTransactions.toList());

//       final totalAmountOfAllTransactions =
//           getTotalAmountOfAllTransactions(
//               transactions.toList());

//       if (totalAmount > 0 &&
//           totalAmountOfAllTransactions > 0) {
//         final percentage =
//             (totalAmount / totalAmountOfAllTransactions) *
//                 100;
//         return '${percentage.toStringAsFixed(2)}%';
//       } else {
//         return '';
//       }
//     },
//     loading: () => '',
//     error: (error, stackTrace) {
//       debugPrint(error.toString());
//       return '';
//     },
//   );
// },
