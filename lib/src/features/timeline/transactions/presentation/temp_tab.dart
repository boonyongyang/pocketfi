import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/budget/wallet/application/wallet_visibility.dart';
import 'package:pocketfi/src/features/budget/wallet/data/user_wallets_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet.dart';
import 'package:pocketfi/src/features/shared/services/shared_preferences_service.dart';
import 'package:pocketfi/src/features/timeline/transactions/application/transaction_provider.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/transactions_list_view.dart';

class TempTab extends ConsumerWidget {
  const TempTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(userTransactionsProvider);
    final wallets = ref.watch(userWalletsProvider).value;
    final selectedWallet = ref.watch(selectedWalletProvider);

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
            return Column(
              children: [
                // border radius button
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
                  child: const Text('Wallets (1/2)'),
                ),
                Expanded(
                  child: TransactionListView(
                    transactions: trans,
                  ),
                ),
              ],
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

class WalletVisibilitySheet extends ConsumerStatefulWidget {
  const WalletVisibilitySheet({
    Key? key,
    required this.wallets,
    required this.selectedWallet,
  }) : super(key: key);

  final List<Wallet>? wallets;
  final Wallet? selectedWallet;

  @override
  WalletVisibilityState createState() => WalletVisibilityState();
}

class WalletVisibilityState extends ConsumerState<WalletVisibilitySheet> {
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
                  splashRadius: 24.0,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.mainColor1,
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
                    onPressed: () async {
                      ref
                          .read(walletVisibilityProvider.notifier)
                          .toggleVisibility(wallet!);

                      // final walletVisibilityString ;

// * convert Map<Wallet,bool> to Map<String,bool>
                      Map<Wallet, bool> walletMap =
                          walletVisibility; // original map

                      Map<String, bool> walletIdMap = {};

                      for (final entry in walletMap.entries) {
                        walletIdMap[entry.key.walletId] = entry.value;
                      }
// * convert Map<Wallet,bool> to Map<String,bool>

                      if (await SharedPreferencesService
                          .saveWalletVisibilitySettings(walletIdMap)) {
                        debugPrint('Saved wallet visibility settings');
                      }

                      final getWalVisiPrefs = SharedPreferencesService
                          .getWalletVisibilitySettings();

                      debugPrint(
                          'Get wallet visibility settings: ${getWalVisiPrefs.toString()}');

                      for (var wallet
                          in ref.watch(walletVisibilityProvider).entries) {
                        debugPrint(
                          'walletVisibility: ${wallet.key.walletName} ${wallet.value}',
                        );
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
