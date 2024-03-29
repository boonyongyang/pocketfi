import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/shared/image_upload/data/image_file_notifier.dart';
import 'package:pocketfi/src/features/tags/application/tag_services.dart';
import 'package:pocketfi/src/features/tags/data/tag_repository.dart';
import 'package:pocketfi/src/features/transactions/application/transaction_services.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/transactions/presentation/transaction_card.dart';
import 'package:pocketfi/src/features/transactions/presentation/update_transaction.dart';
import 'package:pocketfi/src/features/wallets/application/wallet_services.dart';
import 'package:pocketfi/src/features/wallets/data/wallet_repository.dart';

class TransactionListView extends ConsumerWidget {
  final Iterable<Transaction> transactions;

  const TransactionListView({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double? totalExpenseOnLastDisplayedDate;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(8.0),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions.elementAt(index);

        final isLastTransactionForDate =
            _isLastTransactionForDate(index, transaction);

        if (isLastTransactionForDate) {
          totalExpenseOnLastDisplayedDate =
              _getNetAmountOnDate(transaction.date);
        }

        // final scheduledTransactions = _getScheduledTransactions();
        // final hasScheduledTransactions = scheduledTransactions.isNotEmpty;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLastTransactionForDate)
              TransactonDateRow(
                date: transaction.date,
                netAmount: totalExpenseOnLastDisplayedDate!,
              ),
            TransactionCard(
              transaction: transaction,
              onTapped: () async {
                // setNewTransactionState(ref);
                ref
                    .read(selectedTransactionProvider.notifier)
                    .setSelectedTransaction(transaction);
                // if (transaction.receipt?.transactionImage != null) {
                //   ref.read(imageFileProvider.notifier).setImageFile(
                //       // ! recheck this fileUrl!
                //       File(transaction.receipt!.transactionImage!.fileUrl
                //           .toString()));

                //   debugPrint(
                //       'imageFileProvider is ${ref.read(imageFileProvider)}');
                // }

                if (transaction.transactionImage?.fileUrl != null) {
                  ref.read(imageFileProvider.notifier).setImageFile(
                      // ! recheck this fileUrl!
                      File(transaction.transactionImage!.fileUrl.toString()));

                  debugPrint(
                      'imageFileProvider is ${ref.read(imageFileProvider)}');
                }

                final allTags = ref.watch(userTagsProvider).value?.toList();

                // loop through allTags and set isSelected for each tag that is in the transaction
                if (allTags != null && allTags.isNotEmpty) {
                  ref.read(userTagsNotifier.notifier).resetTagsState(ref);
                  for (final tag in allTags) {
                    if (transaction.tags.contains(tag.name)) {
                      ref.read(userTagsNotifier.notifier).setTagToSelected(
                            getTagWithName(tag.name, allTags)!,
                          );
                    }
                  }
                }

                final chosenWallet = await getWalletById(transaction.walletId);

                // set wallet to selected transaction wallet
                // ref.read(selectedWalletProvider.notifier).state =
                //     selectedWallet;

                ref
                    .read(selectedWalletProvider.notifier)
                    .setSelectedWallet(chosenWallet);
                debugPrint(
                    'selWallet is ${ref.read(selectedWalletProvider)?.walletName}');

                // // set tags state from selectedTransaction
                // ref.read(userTagsNotifier.notifier).setTags(getTagsWithTagNames(
                //       transaction.tags,
                //       allTags ?? [],
                //     ));

                // debugPrint(
                // 'bool is ${ref.read(selectedTransactionProvider)?.isBookmark}');
                // debugPrint('isBool is ${ref.read(isBookmarkProvider)}');

                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => const UpdateTransaction(),
                    fullscreenDialog: true,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // // Method to filter scheduled transactions
  // List<Transaction> _getScheduledTransactions() {
  //   return transactions
  //       .where((transaction) => transaction.date
  //           .isAfter(DateTime.now().add(const Duration(days: 1))))
  //       .toList();
  // }

  // // Method to create the scheduled transactions widget
  // Widget _buildScheduledTransactionsWidget(
  //     List<Transaction> scheduledTransactions) {
  //   return Container(
  //     padding: const EdgeInsets.all(8.0),
  //     decoration: BoxDecoration(
  //       color: Colors.grey,
  //       borderRadius: BorderRadius.circular(10.0),
  //     ),
  //     child: Column(
  //       children: [
  //         const Text(
  //           "Scheduled Transactions",
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.white,
  //           ),
  //         ),
  //         Text(
  //           // make plural if more than one transaction
  //           "${scheduledTransactions.length} ${scheduledTransactions.length == 1 ? 'transaction' : 'transactions'}",
  //           style: const TextStyle(
  //             fontSize: 14,
  //             color: Colors.white,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  bool _isLastTransactionForDate(int index, Transaction transaction) {
    // Check if the transaction is the last one for its date
    if (index == 0) return true;
    final previousTransaction = transactions.elementAt(index - 1);
    return !_areDatesEqual(transaction.date, previousTransaction.date);
  }

  bool _areDatesEqual(DateTime date1, DateTime date2) {
    // Check if two dates are equal
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  double _getNetAmountOnDate(DateTime date) {
    // Calculate the net amount for a date
    final transactionsOnDate = transactions
        .where((transaction) => _areDatesEqual(transaction.date, date));

    double netAmount = 0.0;

    for (final transaction in transactionsOnDate) {
      if (transaction.type == TransactionType.expense) {
        netAmount -= transaction.amount;
      } else if (transaction.type == TransactionType.income) {
        netAmount += transaction.amount;
      }
    }
    return netAmount;
  }
}

class TransactonDateRow extends StatefulWidget {
  const TransactonDateRow({
    super.key,
    required this.date,
    required this.netAmount,
  });
  final DateTime date;
  final double netAmount;

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
      return Strings.today;
    } else if (selectedDate.year == yesterday.year &&
        selectedDate.month == yesterday.month &&
        selectedDate.day == yesterday.day) {
      return Strings.yesterday;
    } else if (selectedDate.year == tomorrow.year &&
        selectedDate.month == tomorrow.month &&
        selectedDate.day == tomorrow.day) {
      return Strings.tomorrow;
    } else {
      return DateFormat('EEE, d MMM').format(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    String netAmountString = widget.netAmount.abs().toStringAsFixed(2);
    if (widget.netAmount > 0) {
      netAmountString = 'MYR $netAmountString';
    } else if (widget.netAmount == 0) {
      netAmountString = '0.00';
    } else {
      netAmountString = '- MYR $netAmountString';
    }
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
      child: Container(
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
              ),
            ),
            Text(
              netAmountString,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
