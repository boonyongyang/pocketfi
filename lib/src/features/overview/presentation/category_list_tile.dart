import 'package:flutter/material.dart';
import 'package:pocketfi/src/features/overview/presentation/category_detail_page.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';

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
                  style: const TextStyle(fontSize: 14),
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
