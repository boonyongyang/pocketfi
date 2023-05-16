import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/budgets/application/budget_services.dart';
import 'package:pocketfi/src/features/budgets/domain/budget.dart';
import 'package:pocketfi/src/features/category/application/category_services.dart';
import 'package:pocketfi/src/features/transactions/data/transaction_repository.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/wallets/data/wallet_repository.dart';

class BudgetTile extends ConsumerWidget {
  final Budget budget;
  final VoidCallback onTap;
  const BudgetTile({
    super.key,
    required this.budget,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userTransactions = ref.watch(userTransactionsProvider);

    final currentMonthTransactions = userTransactions.when<List<Transaction>>(
      data: (transactions) => transactions.where((tran) {
        return tran.date.month == DateTime.now().month &&
            tran.date.year == DateTime.now().year &&
            tran.categoryName == budget.categoryName &&
            tran.walletId == budget.walletId;
      }).toList(),
      loading: () => [],
      error: (error, stackTrace) {
        debugPrint(error.toString());
        return [];
      },
    );
    // get absolute value of total amount
    final spentAmount = getCategoryTotalAmount(currentMonthTransactions).abs();
    if (spentAmount != budget.usedAmount) {
      updateUsedAmount(
        budget,
        spentAmount,
        ref,
      );
    }
    final spentPercentage = spentAmount / budget.budgetAmount;
    final category = getCategoryWithCategoryName(budget.categoryName);
    final remainingAmount = budget.budgetAmount - spentAmount;
    final wallet = ref.watch(getWalletWithWalletId(budget.walletId)).value;
    if (wallet == null) {
      return Container();
    }
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 8.0,
          bottom: 8.0,
        ),
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
                offset: const Offset(3, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            budget.budgetName,
                            style: const TextStyle(
                              color: AppColors.mainColor1,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'MYR ${budget.budgetAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: AppColors.mainColor1,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.wallet,
                            color: Colors.grey[600],
                            size: 14,
                          ),
                          Text(
                            ' ${wallet.walletName}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: LinearProgressIndicator(
                              minHeight: 25,
                              value: spentPercentage,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                category.color,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                              top: 4.0,
                              bottom: 4.0,
                            ),
                            child: Text(
                                '${(spentPercentage * 100).toStringAsFixed(2)}%',
                                style: TextStyle(
                                  color: spentPercentage * 100 > 16
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: 'used ',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: 'MYR ${spentAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: category.color),
                            child: Center(child: category.icon),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(budget.categoryName),
                          const Spacer(),
                          Text.rich(
                            TextSpan(
                              text: 'left ',
                              style: TextStyle(
                                color: remainingAmount < 0
                                    ? AppColors.red
                                    : Colors.grey,
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      'MYR ${remainingAmount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: remainingAmount < 0
                                        ? AppColors.red
                                        : Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateUsedAmount(
    Budget budget,
    double totalAmount,
    WidgetRef ref,
  ) async {
    ref
        .read(budgetProvider.notifier)
        .updateUsedAmount(budgetId: budget.budgetId, usedAmount: totalAmount);
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
