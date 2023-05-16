import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/wallets/application/wallet_services.dart';
import 'package:pocketfi/src/features/wallets/data/wallet_repository.dart';

class SelectWalletDropdownList extends ConsumerWidget {
  const SelectWalletDropdownList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallets = ref.watch(userWalletsProvider).value;
    final selectedWallet = ref.watch(selectedWalletProvider);
    final walletList = wallets?.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Consumer(
        builder: (context, ref, child) {
          return DropdownButton(
            value: selectedWallet ?? walletList?.first,
            items: walletList?.map((wallet) {
              return DropdownMenuItem(
                value: wallet,
                child: Text(wallet.walletName),
              );
            }).toList(),
            onChanged: (selectedWallet) {
              ref
                  .read(selectedWalletProvider.notifier)
                  .setSelectedWallet(selectedWallet);
            },
          );
        },
      ),
    );
  }
}
