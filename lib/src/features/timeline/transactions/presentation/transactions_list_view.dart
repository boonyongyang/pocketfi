import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/timeline/transactions/data/transaction_notifiers.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/transaction_card.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/update_transaction.dart';

class TransactionListView extends ConsumerWidget {
  final Iterable<Transaction> transactions;

  const TransactionListView({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: const Color(0xFFE1DCDC),
      constraints: const BoxConstraints(
          // minWidth: 100.0,
          // maxWidth: 320.0,
          // minHeight: 100.0,
          // maxHeight: 600.0,
          ),
      child: ListView.builder(
        // shrinkWrap: true,
        padding: const EdgeInsets.all(8.0),
        // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //   crossAxisCount: 1, // number of columns
        //   mainAxisSpacing: 8.0, // vertical spacing
        //   crossAxisSpacing: 8.0, // horizontal spacing
        // ),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction =
              transactions.elementAt(index); // get the post at the index
          return TransactionCard(
            transaction: transaction,
            transactionType: transaction.type,
            onTapped: () {
              // debugPrint('selectedDate is ${transaction.date}');
              // debugPrint('now  is ${DateTime.now()}');

              ref
                  .read(selectedTransactionProvider.notifier)
                  .setSelectedTransaction(transaction, ref);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UpdateTransaction(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
