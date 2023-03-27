import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/transactions/data/transaction_repository.dart';
import 'package:pocketfi/src/features/transactions/presentation/transactions_list_view.dart';

class TransactionsTabView extends ConsumerWidget {
  const TransactionsTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(userTransactionsProvider);
    // debugPrint('transactions are $transactions');

    return RefreshIndicator(
      onRefresh: () {
        ref.refresh(userTransactionsProvider);
        return Future.delayed(
          const Duration(
            milliseconds: 500,
          ),
        );
      },
      child: transactions.when(
        data: (trans) {
          if (trans.isEmpty) {
            return const EmptyContentsWithTextAnimationView(
              text: Strings.youHaveNoPosts,
            );
          } else {
            return TransactionListView(
              transactions: trans,
            );
          }
        },
        error: (error, stackTrace) {
          return const ErrorAnimationView();
        },
        loading: () {
          return const LoadingAnimationView();
        },
      ),
    );
  }
}
