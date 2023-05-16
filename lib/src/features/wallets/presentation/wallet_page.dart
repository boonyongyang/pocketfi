import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/wallets/application/wallet_services.dart';
import 'package:pocketfi/src/features/wallets/data/wallet_repository.dart';
import 'package:pocketfi/src/features/wallets/presentation/update_wallet.dart';
import 'package:pocketfi/src/features/wallets/presentation/wallet_tiles.dart';

import 'add_new_wallet.dart';

class WalletPage extends ConsumerWidget {
  const WalletPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallets = ref.watch(userWalletsProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Wallets'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => const AddNewWallet(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return await ref.refresh(userWalletsProvider);
        },
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 4,
              child: wallets.when(data: (wallets) {
                if (wallets.isEmpty) {
                  return const SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: EmptyContentsWithTextAnimationView(
                        text: Strings.noWalletsYet),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.refresh(userWalletsProvider);
                    return Future.delayed(const Duration(seconds: 1));
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: wallets.length,
                    itemBuilder: (context, index) {
                      final wallet = wallets.elementAt(index);
                      return WalletTiles(
                        wallet: wallet,
                        onTap: () {
                          ref
                              .read(selectedWalletProvider.notifier)
                              .setSelectedWallet(wallet);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const UpdateWallet(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              }, error: ((error, stackTrace) {
                return const ErrorAnimationView();
              }), loading: () {
                return const LoadingAnimationView();
              }),
            ),
          ],
        ),
      ),
    );
  }
}
