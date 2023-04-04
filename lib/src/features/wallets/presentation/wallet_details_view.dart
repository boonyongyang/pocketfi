import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/budgets/application/budget_services.dart';
import 'package:pocketfi/src/features/category/application/category_services.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/overview/presentation/overview_month_selector.dart';
import 'package:pocketfi/src/features/transactions/application/transaction_services.dart';
import 'package:pocketfi/src/features/transactions/data/transaction_repository.dart';
import 'package:pocketfi/src/features/transactions/date_picker/application/transaction_date_services.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/transactions/presentation/transactions_list_view.dart';
import 'package:pocketfi/src/features/wallets/domain/wallet.dart';
import 'package:pocketfi/src/features/wallets/presentation/update_wallet.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WalletDetailsView extends ConsumerWidget {
  Wallet wallet;
  WalletDetailsView({
    super.key,
    required this.wallet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions =
        ref.watch(userTransactionsInWalletProvider(wallet.walletId));
    final transactionType = ref.watch(transactionTypeProvider);
    final userTransactions = ref.watch(userTransactionsProvider);
    final month = ref.watch(overviewMonthProvider);

    List<Category> categoriesList = ref.watch(expenseCategoriesProvider);
    final currentMonthTransactions = userTransactions.when<List<Transaction>>(
      data: (transactions) => transactions.where((tran) {
        // if data is empty, then the where function will return an empty list
        return tran.date.month == month.month &&
            tran.date.year == month.year &&
            tran.walletId == wallet.walletId;
      }).toList(),
      loading: () => [],
      error: (error, stackTrace) {
        debugPrint(error.toString());
        return [];
      },
    );
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
        title: Text(
          wallet.walletName,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => UpdateWallet(
                    wallet: wallet,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const OverviewMonthSelector(),
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
                      offset: const Offset(3, 6), // changes position of shadow
                    ),
                  ],
                ),
                height: MediaQuery.of(context).size.height * 0.3,
                child: Center(
                  child: filteredCategories.isEmpty
                      ? const Text('No transactions found.')
                      : SfCircularChart(
                          title: ChartTitle(
                              text: 'Transactions in ${wallet.walletName}'),
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
                                return getCategoryTotalAmountForCurrentMonth(
                                  category.name,
                                  currentMonthTransactions,
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
                                final totalAmount = (() {
                                  switch (transactionType) {
                                    case TransactionType.expense:
                                    case TransactionType.income:
                                    case TransactionType.transfer:
                                      final type = transactionType;
                                      final transactionsOfType =
                                          currentMonthTransactions
                                              .where(
                                                  (tran) => tran.type == type)
                                              .toList();
                                      final totalAmountOfType =
                                          getTotalAmount(transactionsOfType);
                                      return totalAmountOfType;
                                  }
                                })();
                                final categoryTotalAmount =
                                    getCategoryTotalAmountForCurrentMonth(
                                        category.name,
                                        currentMonthTransactions);

                                return 'MYR ${categoryTotalAmount.toStringAsFixed(2)}';
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
    );
  }

  double getTotalAmount(List<Transaction> transactions) {
    return transactions.fold<double>(
      0,
      (previousValue, element) => previousValue + element.amount,
    );
  }
}
