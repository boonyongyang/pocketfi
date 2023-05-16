import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/wallets/application/wallet_services.dart';
import 'package:pocketfi/src/features/wallets/data/temp_user_provider.dart';
import 'package:pocketfi/src/features/wallets/data/wallet_repository.dart';
import 'package:pocketfi/src/features/wallets/presentation/add_new_wallet.dart';
import 'package:pocketfi/src/features/wallets/presentation/wallet_details_view.dart';
import 'package:pocketfi/src/features/wallets/presentation/wallet_tiles.dart';

class WalletBottomSheet extends ConsumerWidget {
  const WalletBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallets = ref.watch(userWalletsProvider);
    final userId = ref.watch(userIdProvider);
    return RefreshIndicator(
      onRefresh: () async {
        return await ref.refresh(userWalletsProvider);
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    left: 8.0,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: Colors.transparent,
                    ),
                    onPressed: null,
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Wallets',
                    style: TextStyle(
                      color: AppColors.mainColor1,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      ref
                          .watch(tempDataProvider.notifier)
                          .deleteTempDataInFirebase(userId!);
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => const AddNewWallet(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: wallets.when(
                data: (wallets) {
                  return ListView.builder(
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
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => const WalletDetailsView(),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                error: (error, stackTrace) {
                  return const ErrorAnimationView();
                },
                loading: () {
                  return const LoadingAnimationView();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
