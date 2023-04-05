import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/shared/date_picker/presentation/month_picker.dart';
import 'package:pocketfi/src/features/transactions/application/transaction_services.dart';
import 'package:pocketfi/src/features/transactions/data/transaction_repository.dart';
import 'package:pocketfi/src/features/shared/date_picker/application/date_services.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/transactions/presentation/scheduled_transactions_page.dart';
import 'package:pocketfi/src/features/transactions/presentation/transactions_list_view.dart';
import 'package:pocketfi/src/features/wallets/presentation/wallet_visibility_sheet.dart';

class TransactionsTabView extends ConsumerWidget {
  const TransactionsTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(userTransactionsByMonthByWalletProvider);
    final scheduledTransactions = ref.watch(scheduledTransactionsProvider);
    final hasScheduledTransactions = scheduledTransactions.isNotEmpty;

    return RefreshIndicator(
      onRefresh: () {
        ref.refresh(userTransactionsProvider);
        ref.refresh(overviewMonthProvider.notifier).resetMonth();
        return Future.delayed(
          const Duration(
            milliseconds: 500,
          ),
        );
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  AppColors.mainColor1,
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              onPressed: () {
                // final selectedWallet = ref.read(selectedWalletProvider);
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return const WalletVisibilitySheet();
                  },
                );
              },
              child: const Text('Filter by Wallet'),
            ),
            const SizedBox(height: 10.0),
            const MonthPicker(),
            const SizedBox(height: 10.0),
            transactions.when(
              data: (trans) {
                if (trans.isEmpty) {
                  return const EmptyContentsWithTextAnimationView(
                    text: Strings.youHaveNoRecordsFound,
                  );
                } else {
                  return Column(
                    children: [
                      // if (hasScheduledTransactions && isLastTransactionForDate)
                      if (hasScheduledTransactions)
                        _buildScheduledTransactionsWidget(scheduledTransactions,
                            () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => ScheduledTransactionsPage(
                                transactions: scheduledTransactions,
                              ),
                            ),
                          );
                        }),
                      TransactionListView(
                        transactions: trans,
                      ),
                    ],
                  );
                }
              },
              error: (error, stackTrace) {
                debugPrint('error: $error');
                debugPrint('stackTrace: $stackTrace');
                return const ErrorAnimationView();
              },
              loading: () {
                return const LoadingAnimationView();
              },
            ),
          ],
        ),
      ),
    );
  }

  // // Method to filter scheduled transactions
  // List<Transaction> _getScheduledTransactions(
  //     Iterable<Transaction> transactions) {
  //   // ignore: unnecessary_null_comparison
  //   if (transactions != null) {
  //     return transactions
  //         .where((transaction) => transaction.date
  //             .isAfter(DateTime.now().add(const Duration(days: 1))))
  //         .toList();
  //   } else {
  //     return [];
  //   }
  // }

  // Method to create the scheduled transactions widget
  Widget _buildScheduledTransactionsWidget(
      List<Transaction> scheduledTransactions, onTapped) {
    return GestureDetector(
      onTap: onTapped,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(40.0)),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            color: Colors.grey[200],
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey),
                  child: const Center(
                      child: Icon(
                    Icons.schedule,
                    color: Colors.white,
                  )),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Scheduled Transactions",
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      "${scheduledTransactions.length} ${scheduledTransactions.length == 1 ? 'transaction' : 'transactions'}",
                      style: const TextStyle(
                        // fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
