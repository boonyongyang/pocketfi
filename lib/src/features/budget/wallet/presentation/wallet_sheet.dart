
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/budget/wallet/data/user_wallets_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet.dart';
import 'package:pocketfi/src/features/budget/wallet/presentation/wallet_details_view.dart';
import 'package:pocketfi/src/features/budget/wallet/presentation/wallet_tiles.dart';

class WalletSheet extends ConsumerWidget {
  // final Iterable<Wallet> wallets;
  // final Wallet wallet;

  const WalletSheet({
    super.key,
    // required this.wallet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallets = ref.watch(userWalletsProvider);

    // final request = useState(
    //   RequestForWallets(
    //     walletId: widget.wallet.walletId,
    //   ),
    // );

    // final specificWallet = ref.watch(specificWalletProvider(request.value));

    return SizedBox(
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
                  // visualDensity: VisualDensity.standard,
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
                    context.beamToNamed('createNewWallet');
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
                      // specificWallet.when(data: (specificWallet) {
                      // final walletId = specificWallet.wallet.walletId;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WalletDetailsView(
                            wallet: wallet,
                          ),
                        ),
                      );

                      // );

                      // show snackbar code
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //     content: Text('Wallet tapped'),
                      //   ),
                      // );
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
          ))
        ],
      ),
    );
  }
}
