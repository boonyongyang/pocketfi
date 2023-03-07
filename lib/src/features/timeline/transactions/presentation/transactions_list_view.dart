import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
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
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TODO: to check if the number of transaction on that day is more than 1? if yes, then only show at latest one,
              TransactonDateRow(date: transaction.date),
              TransactionCard(
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
              ),
            ],
          );
        },
      ),
    );
  }
}

class TransactonDateRow extends StatefulWidget {
  const TransactonDateRow({
    super.key,
    required this.date,
  });
  final DateTime date;

  @override
  TransactonDateRowState createState() => TransactonDateRowState();
}

class TransactonDateRowState extends State<TransactonDateRow> {
  String get _selectedDateText {
    final DateTime selectedDate = widget.date;

    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    if (selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day) {
      return 'Today';
    } else if (selectedDate.year == yesterday.year &&
        selectedDate.month == yesterday.month &&
        selectedDate.day == yesterday.day) {
      return 'Yesterday';
    } else if (selectedDate.year == tomorrow.year &&
        selectedDate.month == tomorrow.month &&
        selectedDate.day == tomorrow.day) {
      return 'Tomorrow';
    } else {
      return DateFormat('EEE, d MMM').format(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[400],
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _selectedDateText,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              // color: Colors.white,
            ),
          ),
          Text(
            '-MYR 50.20',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
