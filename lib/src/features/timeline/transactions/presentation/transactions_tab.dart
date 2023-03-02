import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/timeline/transactions/application/transaction_provider.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/transactions_list_view_test.dart';

class TransactionsTab extends ConsumerWidget {
  const TransactionsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // get the transaction from the provider
    // stream provider will automatically update the UI when the data changes
    final transactions = ref.watch(userTransactionsProvider);

    // return a RefreshIndicator to allow the user to refresh the transaction
    return RefreshIndicator(
      onRefresh: () {
        ref.refresh(userTransactionsProvider);
        return Future.delayed(
          const Duration(
            milliseconds: 500,
          ),
        );
      },
      // return a different widget depending on the state of the transaction
      child: transactions.when(
        // if the transaction are loaded, return a list of transaction
        data: (trans) {
          if (trans.isEmpty) {
            // if there are no transaction, return an empty widget
            return const EmptyContentsWithTextAnimationView(
              text: Strings.youHaveNoPosts,
            );
          } else {
            // if there are transaction, return a list of transaction
            return Container(
              padding: const EdgeInsets.only(top: 20),
              color: Colors.grey,
              child: TransactionListView(
                transactions: trans,
              ),
            );
          }
        },

        // if there is an error, return an error widget
        error: (error, stackTrace) {
          return const ErrorAnimationView();
        },

        // if the transaction are loading, return a loading widget
        loading: () {
          return const LoadingAnimationView();
        },
      ),
    );
  }
}
