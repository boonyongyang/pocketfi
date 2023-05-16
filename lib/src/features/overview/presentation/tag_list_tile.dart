import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/overview/application/overview_services.dart';
import 'package:pocketfi/src/features/overview/presentation/tag_detail_page.dart';
import 'package:pocketfi/src/features/transactions/application/transaction_services.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';

class TagListTile extends ConsumerWidget {
  const TagListTile({
    Key? key,
    required this.tagName,
  }) : super(key: key);

  final String tagName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(transactionTypeProvider);
    final currentMonthTransactions =
        ref.watch(currentMonthTransactionsProvider);
    final transactionsOfType =
        currentMonthTransactions.where((tran) => tran.type == type).toList();
    final tagTransactions = transactionsOfType
        .where((tran) => tran.tags.contains(tagName) && tran.type == type)
        .toList();
    final numTransactions = tagTransactions.length;
    final tagTotalAmount = getTotalAmount(tagTransactions);
    final amountStr = 'MYR ${tagTotalAmount.toStringAsFixed(2)}';

    if (tagTransactions.isNotEmpty) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TagDetailPage(tagName: tagName),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: const Icon(
                  Icons.label_outline_sharp,
                  color: AppColors.mainColor1,
                ),
              ),
              const SizedBox(width: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tagName,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.mainColor1,
                    ),
                  ),
                  Text(
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
    } else {
      return const SizedBox();
    }
  }

  double getTotalAmount(List<Transaction> transactions) {
    return transactions.fold<double>(
      0,
      (previousValue, element) => previousValue + element.amount,
    );
  }
}
