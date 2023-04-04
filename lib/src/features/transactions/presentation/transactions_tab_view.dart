import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/overview/presentation/overview_month_selector.dart';
import 'package:pocketfi/src/features/transactions/data/transaction_repository.dart';
import 'package:pocketfi/src/features/transactions/date_picker/application/transaction_date_services.dart';
import 'package:pocketfi/src/features/transactions/presentation/transactions_list_view.dart';
import 'package:pocketfi/src/features/wallets/application/wallet_services.dart';
import 'package:pocketfi/src/features/wallets/application/wallet_visibility.dart';
import 'package:pocketfi/src/features/wallets/data/wallet_repository.dart';
import 'package:pocketfi/src/features/wallets/domain/wallet.dart';

class TransactionsTabView extends ConsumerWidget {
  const TransactionsTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final transactions = ref.watch(userTransactionsProvider);
    // final transactions = ref.watch(userTransactionsByMonthProvider);
    final transactions = ref.watch(userTransactionsByMonthByWalletProvider);
    final wallets = ref.watch(userWalletsProvider).value;
    // final walletList = wallets?.toList();

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
            const SizedBox(height: 20.0),
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
                final selectedWallet = ref.read(selectedWalletProvider);
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return WalletVisibilitySheet(
                      wallets: wallets?.toList(),
                      selectedWallet: selectedWallet,
                    );
                  },
                );
              },
              child: const Text('Filter by Wallet'),
            ),
            const OverviewMonthSelector(),
            const SizedBox(height: 20.0),
            transactions.when(
              data: (trans) {
                if (trans.isEmpty) {
                  return const EmptyContentsWithTextAnimationView(
                    text: Strings.youHaveNoRecordsFound,
                  );
                } else {
                  return TransactionListView(
                    transactions: trans,
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
}

class WalletVisibilitySheet extends ConsumerStatefulWidget {
  const WalletVisibilitySheet({
    Key? key,
    required this.wallets,
    required this.selectedWallet,
  }) : super(key: key);

  final List<Wallet>? wallets;
  final Wallet? selectedWallet;

  @override
  WalletVisibilitySheetState createState() => WalletVisibilitySheetState();
}

class WalletVisibilitySheetState extends ConsumerState<WalletVisibilitySheet> {
  @override
  Widget build(BuildContext context) {
    final wallets = ref.watch(userWalletsProvider).value;
    final walletVisibility = ref.watch(walletVisibilityProvider);

    return SizedBox(
      height: (wallets?.length ?? 1) * 100, // haha for fun only
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 12.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Available Wallets',
                    style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.check_circle_outline,
                    size: 28.0,
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            shrinkWrap: true,
            itemCount: wallets?.length ?? 0,
            itemBuilder: (context, index) {
              final wallet = wallets?.toList()[index];
              return ListTile(
                leading: const Icon(Icons.wallet),
                title: Text(wallet?.walletName ?? 'Null Wallet',
                    style: Theme.of(context).textTheme.titleMedium),
                trailing: IconButton(
                    onPressed: () {
                      ref
                          .read(walletVisibilityProvider.notifier)
                          .toggleVisibility(wallet!);
                      for (var wallet
                          in ref.watch(walletVisibilityProvider).entries) {
                        debugPrint(
                            'walletVisibility: ${wallet.key.walletName} ${wallet.value}');
                      }
                    },
                    icon: Icon(
                      walletVisibility[wallet] == true
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: walletVisibility[wallet] == true
                          ? Colors.green
                          : Colors.grey,
                      size: 32.0,
                    )),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          ),
        ],
      ),
    );
  }
}
