import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/overview/application/overview_services.dart';
import 'package:pocketfi/src/features/overview/presentation/category_detail_page.dart';
import 'package:pocketfi/src/features/transactions/application/transaction_services.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';

class CategoryListTile extends ConsumerWidget {
  const CategoryListTile({
    Key? key,
    required this.categoryName,
    required this.icon,
    required this.color,
    // required this.currentMonthTransactions,
    // required this.type,
  }) : super(key: key);

  final String categoryName;
  final Icon icon;
  final Color color;
  // final List<Transaction> currentMonthTransactions;
  // final TransactionType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(transactionTypeProvider);

    final currentMonthTransactions =
        ref.watch(currentMonthTransactionsProvider);

    final transactionsOfType =
        currentMonthTransactions.where((tran) => tran.type == type).toList();
    // debugPrint('transactionsOfType: $transactionsOfType');

    final totalAmountOfType = getTotalAmount(transactionsOfType);

    final categoryTransactions = transactionsOfType
        .where((tran) => tran.categoryName == categoryName)
        .toList();
    // debugPrint('categoryTransactions: $categoryTransactions');

    final numTransactions = categoryTransactions.length;
    // debugPrint('numTransactions: $numTransactions');

    final categoryTotalAmount = getTotalAmount(categoryTransactions);
    // debugPrint('categoryTotalAmount: $categoryTotalAmount');

    final percentageStr = totalAmountOfType > 0
        ? (categoryTotalAmount / totalAmountOfType * 100).toStringAsFixed(1)
        : '0.0';
    // debugPrint('percentageStr: $percentageStr');

    final amountStr = 'MYR ${categoryTotalAmount.toStringAsFixed(2)}';
    // debugPrint('amountStr: $amountStr');

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
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.mainColor1,
                  ),
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
