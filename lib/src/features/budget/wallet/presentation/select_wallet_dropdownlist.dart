import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/budget/wallet/data/user_wallets_provider.dart';

class SelectWalletDropdownList extends ConsumerWidget {
  const SelectWalletDropdownList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallets = ref.watch(userWalletsProvider).value;
    final selectedWallet = ref.watch(selectedWalletProvider);

    debugPrint('first wallets: ${selectedWallet?.walletName}');
    final walletList = wallets?.toList();
    debugPrint('wallet list: ${walletList?.length}');
    debugPrint('wallet list: ${walletList?.toString()}');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Consumer(
        builder: (context, ref, child) {
          return DropdownButton(
            value: selectedWallet,
            items: walletList?.map((wallet) {
              return DropdownMenuItem(
                value: wallet,
                child: Text(wallet.walletName),
              );
            }).toList(),
            onChanged: (selectedWallet) {
              debugPrint('wallet tapped: ${selectedWallet?.walletName}');
              ref.read(selectedWalletProvider.notifier).state = selectedWallet!;
              debugPrint(
                  'selected wallet: ${ref.read(selectedWalletProvider)?.walletName}');
            },
          );
        },
      ),
    );
  }
}

class SelectWalletForBudgetDropdownList extends ConsumerWidget {
  String? walletId;
  SelectWalletForBudgetDropdownList({
    super.key,
    this.walletId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallets = ref.watch(userWalletsProvider).value;
    final selectedWallet = ref.watch(selectedWalletForBudgetProvider);

    debugPrint('first wallets: ${selectedWallet?.walletName}');
    final walletList = wallets?.toList();
    debugPrint('wallet list: ${walletList?.length}');
    debugPrint('wallet list: ${walletList?.toString()}');

    return Consumer(
      builder: (context, ref, child) {
        return DropdownButton(
          value: selectedWallet,
          items: walletList?.map((wallet) {
            return DropdownMenuItem(
              value: wallet,
              child: Text(wallet.walletName),
            );
          }).toList(),
          onChanged: (selectedWallet) {
            debugPrint('wallet tapped: ${selectedWallet?.walletName}');
            if (walletId == null) {
              ref.read(selectedWalletForBudgetProvider.notifier).state =
                  selectedWallet!;
            }
            //! need to fix this -> need to get wallet with wallet id
            // else {
            //   ref.read(selectedWalletForBudgetProvider.notifier).state =
            // ;
            // }
            debugPrint(
                'selected wallet: ${ref.read(selectedWalletForBudgetProvider)?.walletName}');
          },
        );
      },
    );
  }
}

class SelectWalletForDebtDropdownList extends ConsumerWidget {
  String? walletId;
  SelectWalletForDebtDropdownList({
    super.key,
    this.walletId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallets = ref.watch(userWalletsProvider).value;
    final selectedWallet = ref.watch(selectedWalletForDebtProvider);

    debugPrint('first wallets: ${selectedWallet?.walletName}');
    final walletList = wallets?.toList();
    debugPrint('wallet list: ${walletList?.length}');
    debugPrint('wallet list: ${walletList?.toString()}');

    return Consumer(
      builder: (context, ref, child) {
        return DropdownButton(
          value: selectedWallet,
          items: walletList?.map((wallet) {
            return DropdownMenuItem(
              value: wallet,
              child: Text(wallet.walletName),
            );
          }).toList(),
          onChanged: (selectedWallet) {
            debugPrint('wallet tapped: ${selectedWallet?.walletName}');
            if (walletId == null) {
              ref.read(selectedWalletForDebtProvider.notifier).state =
                  selectedWallet!;
            }
            //! need to fix this -> need to get wallet with wallet id
            // else {
            //   ref.read(selectedWalletForBudgetProvider.notifier).state =
            // ;
            // }
            debugPrint(
                'selected wallet: ${ref.read(selectedWalletForDebtProvider)?.walletName}');
          },
        );
      },
    );
  }
}
// return Center(
//   child: wallets.when(
//     data: (Iterable<Wallet> data) {
//       // final walletList = data?.toList() ?? [];
//       final walletList = data.toList();
//       return DropdownButton(
//         // value: walletList.isNotEmpty ? walletList.first : null,
//         value: selectedWallet,
//         items: walletList.map((wallet) {
//           return DropdownMenuItem(
//             value: wallet,
//             child: Text(wallet.walletName),
//           );
//         }).toList(),
//         onChanged: (selectedWallet) {
//           debugPrint('wallet tapped: ${selectedWallet?.walletName}');
//           ref.read(selectedWalletProvider.notifier).state = selectedWallet!;
//           debugPrint(
//               'selected wallet: ${ref.read(selectedWalletProvider)?.walletName}');
//         },
//       );
//     },
//     loading: () => const CircularProgressIndicator(),
//     error: (error, stackTrace) => Text('Error: $error'),
//   ),
// );