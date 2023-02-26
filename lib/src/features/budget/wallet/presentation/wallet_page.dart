import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/button_widget.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/budget/wallet/application/user_wallets_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/presentation/wallet_details_view.dart';
import 'package:pocketfi/src/features/budget/wallet/presentation/wallet_tiles.dart';

class WalletPage extends ConsumerWidget {
  // final Iterable<Wallet> wallets;
  // final Wallet wallet;

  const WalletPage({
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallets'),
      ),
      body:
          // SafeArea(
          //   child:
          RefreshIndicator(
        onRefresh: () async {
          return await ref.refresh(userWalletsProvider);
          // return Future.delayed(const Duration(seconds: 1));
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
                  // RefreshIndicator(
                  //   child: const EmptyContentsWithTextAnimationView(
                  //       text: Strings.noWalletsYet),
                  //   onRefresh: () async {
                  //     ref.refresh(userWalletsProvider);
                  //     return Future.delayed(const Duration(seconds: 1));
                  //   },
                  // );

                  // CreateNewWalletButtonWidget(),
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
          backgroundColor: AppColors.mainColor1,
          foregroundColor: AppColors.white,
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

          Beamer.of(context).beamToNamed('createNewWallet');
        },
        child: const ButtonWidget(
          text: Strings.createNewWallet,
        ),
      ),
    );
  }
}
