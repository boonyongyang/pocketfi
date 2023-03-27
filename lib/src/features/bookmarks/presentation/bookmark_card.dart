import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/category/application/category_services.dart';
import 'package:pocketfi/src/features/transactions/application/transaction_services.dart';
import 'package:pocketfi/src/features/transactions/data/transaction_repository.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';

class BookmarkCard extends ConsumerWidget {
  const BookmarkCard({
    super.key,
    required this.transaction,
    required this.onTapped,
  });

  final Transaction transaction;
  final VoidCallback onTapped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionCategory =
        getCategoryWithCategoryName(transaction.categoryName);
    final transactionType = transaction.type;

    final t = ref.read(selectedTransactionProvider);
    debugPrint('T: ${t?.isBookmark}');

    return Dismissible(
      key: ValueKey(transaction.transactionId),
      behavior: HitTestBehavior.translucent, // idk what is this
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text(
                'Do you want to remove the transaction from the list?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                  // ref
                  //     .read(selectedTransactionProvider.notifier)
                  //     .toggleBookmark(ref);

                  // update transaction
                  ref
                      .read(transactionProvider.notifier)
                      .toogleBookmark(transaction: transaction);

                  debugPrint('tt: ${t?.isBookmark}');
                },
                child:
                    const Text('Remove', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        // make isBookmark false
        // ref.read(selectedTransactionProvider.notifier).toggleBookmark(ref);
        debugPrint('onDismissed: $direction');
        // debugPrint('t: ${t?.isBookmark}');
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: GestureDetector(
        onTap: onTapped,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 22.0,
                        backgroundColor: transactionCategory.color,
                        child: transactionCategory.icon,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction.categoryName,
                            ),
                            Text(transaction.description ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                )),
                            if (transaction.transactionImage?.thumbnailUrl !=
                                null)
                              Image.network(
                                transaction.transactionImage!.thumbnailUrl!,
                                height: 100,
                                // width: 100,
                                fit: BoxFit.cover,
                              )
                            else
                              const SizedBox(),
                            // Text(DateFormat('d MMM')
                            //     .format(transaction.date)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '${transactionType == TransactionType.expense ? TransactionType.expense.symbol : transactionType == TransactionType.income ? TransactionType.income.symbol : TransactionType.transfer.symbol}MYR ${transaction.amount}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: transactionType == TransactionType.expense
                          ? TransactionType.expense.color
                          : transactionType == TransactionType.income
                              ? TransactionType.income.color
                              : TransactionType.transfer.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
