import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/budgets/application/budget_services.dart';
import 'package:pocketfi/src/features/budgets/presentation/detail_budget_overview.dart';
import 'package:pocketfi/src/features/budgets/presentation/update_budget.dart';
import 'package:pocketfi/src/features/category/application/category_services.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/shared/date_picker/presentation/month_picker.dart';
import 'package:pocketfi/src/features/transactions/application/transaction_services.dart';
import 'package:pocketfi/src/features/transactions/data/transaction_repository.dart';
import 'package:pocketfi/src/features/shared/date_picker/application/date_services.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/transactions/presentation/transactions_list_view.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class BudgetDetailsView extends ConsumerWidget {
  const BudgetDetailsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBudget = ref.watch(selectedBudgetProvider);
    final transactionType = ref.watch(transactionTypeProvider);
    final transactions =
        ref.watch(userTransactionsInBudgetProvider(selectedBudget!.budgetId));
    final userTransactions = ref.watch(userTransactionsProvider);
    final month = ref.watch(
        overviewMonthProvider); // ! make a separate one so won't affect by the other

    List<Category> categoriesList = ref.watch(expenseCategoriesProvider);
    final currentMonthTransactions = userTransactions.when<List<Transaction>>(
      data: (transactions) => transactions.where((tran) {
        // if data is empty, then the where function will return an empty list
        return tran.date.month == month.month &&
            tran.date.year == month.year &&
            tran.categoryName == selectedBudget.categoryName &&
            tran.walletId == selectedBudget.walletId;
      }).toList(),
      loading: () => [],
      error: (error, stackTrace) {
        debugPrint(error.toString());
        return [];
      },
    );

    final spentAmount = getCategoryTotalAmount(currentMonthTransactions).abs();
    final spentPercentage = (spentAmount / selectedBudget.budgetAmount) * 100;
    final remainingAmount = selectedBudget.budgetAmount - spentAmount;

    final getCategory =
        getCategoryWithCategoryName(selectedBudget.categoryName);
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

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(selectedBudget.budgetName),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UpdateBudget(
                        // budget: budget,
                        ),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () {
            ref.refresh(userTransactionsProvider);
            ref.refresh(overviewMonthProvider.notifier).resetMonth();
            return Future.delayed(
              const Duration(
                milliseconds: 500,
              ),
            );
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const MonthPicker(),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Amount left to spend',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: AppColors.mainColor1,
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'MYR ${remainingAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainColor2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(
                //     left: 16.0,
                //     right: 16.0,
                //     top: 16.0,
                //     bottom: 0.0,
                //   ),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: const BorderRadius.all(
                //         Radius.circular(20),
                //       ),
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.grey.withOpacity(0.5),
                //           spreadRadius: 2,
                //           blurRadius: 7,
                //           offset:
                //               const Offset(3, 6), // changes position of shadow
                //         ),
                //       ],
                //     ),
                //     // height: MediaQuery.of(context).size.height * 0.3,
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Column(
                //         children: [
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Text('Amount left to spend',
                //                   style: TextStyle(
                //                     fontSize: 12,
                //                     fontWeight: FontWeight.normal,
                //                     color: AppColors.mainColor1,
                //                   )),
                //             ],
                //           ),
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Text(
                //                 'MYR ${remainingAmount.toStringAsFixed(2)}',
                //                 style: TextStyle(
                //                   fontSize: 20,
                //                   fontWeight: FontWeight.bold,
                //                   color: AppColors.mainColor2,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
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
                          offset:
                              const Offset(3, 6), // changes position of shadow
                        ),
                      ],
                    ),
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Center(
                      child: filteredCategories.isEmpty
                          ? const Text('No transactions found.')
                          : SfRadialGauge(
                              title: const GaugeTitle(
                                text: 'Budget Summary',
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.mainColor1,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              axes: <RadialAxis>[
                                RadialAxis(
                                  // radiusFactor: 0.55,
                                  // startAngle: 270,
                                  // endAngle: 270,

                                  minimum: 0,
                                  maximum: 100,
                                  showLabels: false,
                                  showTicks: false,
                                  axisLineStyle: AxisLineStyle(
                                    cornerStyle: CornerStyle.bothCurve,
                                    thickness: 0.2,
                                    color: Colors.grey[300],
                                    thicknessUnit: GaugeSizeUnit.factor,
                                  ),
                                  pointers: [
                                    RangePointer(
                                      color: getCategory.color,
                                      value: spentPercentage,
                                      cornerStyle: CornerStyle.bothCurve,
                                      width: 0.2,
                                      sizeUnit: GaugeSizeUnit.factor,
                                    ),
                                  ],
                                  annotations: [
                                    GaugeAnnotation(
                                      widget: Column(
                                        children: [
                                          Text(
                                            'spent',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.normal,
                                              color: getCategory.color,
                                            ),
                                          ),
                                          Text(
                                            'MYR ${spentAmount.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: getCategory.color,
                                            ),
                                          ),
                                        ],
                                      ),
                                      angle: 90,
                                      positionFactor: 1.7,
                                    ),
                                    GaugeAnnotation(
                                      widget: Text(
                                        '${spentPercentage.toStringAsFixed(2)}%',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: getCategory.color,
                                        ),
                                      ),
                                      angle: 90,
                                      positionFactor: 0.1,
                                    ),
                                  ],
                                ),
                              ],
                            ),

                      //     Text.rich(
                      //   TextSpan(
                      //     text: 'Left',
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.normal,
                      //       color: getCategory.color,
                      //     ),
                      //     children: [
                      //       TextSpan(
                      //         text: ' MYR ${remainingAmount.toStringAsFixed(2)}',
                      //         style: TextStyle(
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.bold,
                      //           color: getCategory.color,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // fixedSize: Size(80, 30),
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.mainColor1,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => const DetailBudgetOverview(),
                      ),
                    );
                  },
                  child: Text('${selectedBudget.budgetName}Overview'),
                ),
                TransactionListView(
                  transactions: currentMonthTransactions,
                ),
                // transactions.when(
                //   data: (trans) {
                //     if (trans.isEmpty) {
                //       return const EmptyContentsWithTextAnimationView(
                //         text: Strings.youHaveNoRecords,
                //       );
                //     } else {
                //       return TransactionListView(
                //         transactions: currentMonthTransactions,
                //       );
                //     }
                //   },
                //   error: (error, stackTrace) {
                //     return const ErrorAnimationView();
                //   },
                //   loading: () {
                //     return const LoadingAnimationView();
                //   },
                // ),
              ],
            ),
          ),
        ));
  }

  double getTotalAmount(List<Transaction> transactions) {
    return transactions.fold<double>(
      0,
      (previousValue, element) => previousValue + element.amount,
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
