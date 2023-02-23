import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/tabs/budget/wallet/models/wallet.dart';
import 'package:pocketfi/state/tabs/budget/wallet/models/wallet_request.dart';
import 'package:pocketfi/state/tabs/budget/wallet/provider/specific_wallet_provider.dart';
import 'package:pocketfi/state/tabs/budget/wallet/provider/user_wallets_provider.dart';
import 'package:pocketfi/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/views/components/animations/error_animation_view.dart';
import 'package:pocketfi/views/components/animations/loading_animation_view.dart';
import 'package:pocketfi/views/constants/app_colors.dart';
import 'package:pocketfi/views/constants/strings.dart';
import 'package:pocketfi/views/constants/button_widget.dart';
import 'package:pocketfi/views/tabs/budget/wallet/create_new_wallet_view.dart';
import 'package:pocketfi/views/tabs/budget/wallet/wallet_details_view.dart';
import 'package:pocketfi/views/tabs/budget/wallet/wallet_tiles.dart';

class WalletPage extends ConsumerStatefulWidget {
  // final Iterable<Wallet> wallets;
  // final Wallet wallet;

  const WalletPage({
    super.key,
    // required this.wallet,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  @override
  Widget build(BuildContext context) {
    final wallets = ref.watch(userWalletsProvider);

    // final request = useState(
    //   RequestForWallets(
    //     walletId: widget.wallet.walletId,
    //   ),
    // );

    // final specificWallet = ref.watch(specificWalletProvider(request.value));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallets'),
      ),
      body:
          // SafeArea(
          //   child:
          Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            flex: 4,
            child: wallets.when(data: (wallets) {
              if (wallets.isEmpty) {
                return const EmptyContentsWithTextAnimationView(
                    text: Strings.noWalletsYet);
                // CreateNewWalletButtonWidget(),
              }
              return RefreshIndicator(
                onRefresh: () async {
                  ref.refresh(userWalletsProvider);
                },
                child: ListView.builder(
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
                        // }, error: (Object error, StackTrace stackTrace) {
                        //   return const ErrorAnimationView();
                        // }, loading: () {
                        //   const Center(
                        //     child: CircularProgressIndicator(),
                        //   );
                        // });

                        // );

                        // show snackbar code
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Wallet tapped'),
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
          const Expanded(
            flex: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: CreateNewWalletButtonWidget(),
                ),
              ),
            ),
          ),
        ],
      ),
      // )
      // SingleChildScrollView(
      //     child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.stretch,
      //   children: [
      //     const SizedBox(
      //       height: 10,
      //     ),
      //     GestureDetector(
      //       // go to the detail page of the wallet
      //       onTap: () {},
      //       child: const WalletTiles(
      //         walletName: 'Wallet 1',
      //         walletBalance: 100.00,
      //       ),
      //     ),
      //     // WalletTiles(
      //     //   walletName: 'Wallet 2',
      //     //   walletBalance: 200.00,
      //     // ),
      //     // WalletTiles(
      //     //   walletName: 'Wallet 3',
      //     //   walletBalance: 300.00,
      //     // ),
      //     Padding(
      //       padding: const EdgeInsets.all(16.0),
      //       child: ElevatedButton(
      //         style: ElevatedButton.styleFrom(
      //           fixedSize: const Size(80, 55),
      //           backgroundColor: AppSwatches.mainColor1,
      //           foregroundColor: AppSwatches.white,
      //           shape: const RoundedRectangleBorder(
      //             borderRadius: BorderRadius.all(
      //               Radius.circular(25),
      //             ),
      //           ),
      //         ),
      //         onPressed: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (_) => const CreateNewWalletView(),
      //             ),
      //           );
      //         },
      //         child: const CreateNewWalletButton(),
      //       ),
      //     ),
      //   ],
      // )),
    );
  }
}

class CreateNewWalletButtonWidget extends StatelessWidget {
  const CreateNewWalletButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(80, 55),
          backgroundColor: AppSwatches.mainColor1,
          foregroundColor: AppSwatches.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
        ),
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => const CreateNewWalletView(),
          //   ),
          // );

          Beamer.of(context).beamToNamed('budget/wallet');
        },
        child: const ButtonWidget(
          text: Strings.createNewWallet,
        ),
      ),
    );
  }
}
