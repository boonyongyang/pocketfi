import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/wallets/application/wallet_visibility.dart';
import 'package:pocketfi/src/features/wallets/data/wallet_repository.dart';

class WalletVisibilitySheet extends ConsumerStatefulWidget {
  const WalletVisibilitySheet({
    Key? key,
  }) : super(key: key);

  @override
  WalletVisibilitySheetState createState() => WalletVisibilitySheetState();
}

class WalletVisibilitySheetState extends ConsumerState<WalletVisibilitySheet> {
  @override
  Widget build(BuildContext context) {
    final wallets = ref.watch(userWalletsProvider).value;
    final walletVisibility = ref.watch(walletVisibilityProvider);

    return SizedBox(
      height: (wallets?.length ?? 1) * 110, // haha for fun only
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
