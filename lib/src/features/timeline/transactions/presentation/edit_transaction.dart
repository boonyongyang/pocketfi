import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';

class EditTransaction extends StatefulHookConsumerWidget {
  const EditTransaction({Key? key}) : super(key: key);

  @override
  EditTransactionState createState() => EditTransactionState();
}

class EditTransactionState extends ConsumerState<EditTransaction> {
  void saveTransaction() {
    final selectedTransaction = ref.watch(selectedTransactionTestProvider);

    if (selectedTransaction != null) {
      // ref.read(transactionListProvider.notifier).updateTransaction(
      //     selectedTransaction.copyWith(date: transaction.date));
    } else {
      // ref.read(transactionListProvider.notifier).addTransaction(transaction);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final selectedTransaction = ref.watch(selectedTransactionTestProvider);
    final selectedDate = selectedTransaction?.date ?? DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Transaction'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            DateFormat.yMMMMd().format(selectedDate),
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          IconButton(
            onPressed: () => _selectDate(context, selectedDate),
            icon: const Icon(Icons.calendar_today_rounded),
          ),
          const SizedBox(height: 16),
          // Other transaction fields
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime initialDate) async {
    final selectedTransaction = ref.watch(selectedTransactionTestProvider);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      // ref.read(selectedTransactionProvider.notifier).setTransaction(
      //       selectedTransaction?.copyWith(date: picked),
      //     );
    }
  }
}

final selectedTransactionTestProvider =
    StateNotifierProvider<SelectedTransactionNotifier, Transaction?>(
  (_) => SelectedTransactionNotifier(null),
);

class SelectedTransactionNotifier extends StateNotifier<Transaction?> {
  SelectedTransactionNotifier(Transaction? transaction) : super(transaction);

  void setTransaction(Transaction? transaction) {
    state = transaction;
  }
}

final transactionListProvider =
    StateNotifierProvider<TransactionListNotifier, List<Transaction>>(
  (ref) => TransactionListNotifier(),
);

class TransactionListNotifier extends StateNotifier<List<Transaction>> {
  TransactionListNotifier() : super([]);

  Future<void> addTransaction(Transaction transaction) async {
    state = [...state, transaction];
  }

  Future<void> updateTransaction(
      String transactionId, Transaction updatedTransaction) async {
    state = state.map((transaction) {
      if (transaction.transactionId == updatedTransaction.transactionId) {
        return updatedTransaction;
      } else {
        return transaction;
      }
    }).toList();
  }

  Future<void> deleteTransaction(String transactionId) async {
    state = state.where((transaction) {
      return transaction.transactionId != transactionId;
    }).toList();
  }
}
