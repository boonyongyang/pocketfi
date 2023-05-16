import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/transactions/presentation/transactions_list_view.dart';

class ScheduledTransactionsPage extends ConsumerWidget {
  const ScheduledTransactionsPage({
    super.key,
    required this.transactions,
  });

  final Iterable<Transaction> transactions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Scheduled Transactions"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              TransactionListView(transactions: transactions),
            ],
          ),
        ),
      ),
    );
  }
}
