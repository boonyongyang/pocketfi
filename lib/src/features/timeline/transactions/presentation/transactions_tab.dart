import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/timeline/transactions/application/transaction_provider.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/transactions_list_view.dart';

class TransactionsTab extends ConsumerWidget {
  const TransactionsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(userTransactionsProvider);

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
            return Container(
              padding: const EdgeInsets.only(top: 20),
              color: Colors.grey,
              child: Column(
                children: [
                  // border radius button
                  // ElevatedButton(
                  //   style: ButtonStyle(
                  //     backgroundColor: MaterialStateProperty.all(
                  //       AppColors.mainColor1,
                  //     ),
                  //     shape: MaterialStateProperty.all(
                  //       RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(30.0),
                  //       ),
                  //     ),
                  //   ),
                  //   onPressed: () {
                  //     showModalBottomSheet(
                  //       context: context,
                  //       builder: (context) {
                  //         return WalletVisibilitySheet(
                  //           wallets: wallets?.toList(),
                  //           selectedWallet: selectedWallet,
                  //         );
                  //       },
                  //     );
                  //   },
                  //   child: const Text('Wallets (1/2)'),
                  // ),
                  Expanded(
                    child: TransactionListView(
                      transactions: trans,
                    ),
                  ),
                ],
              ),
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
