import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/dialogs/alert_dialog_model.dart';
import 'package:pocketfi/src/common_widgets/dialogs/delete_dialog.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/application/delete_wallet_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/application/update_wallet_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/data/user_wallets_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet.dart';

class WalletDetailsView extends StatefulHookConsumerWidget {
  final Wallet wallet;

  const WalletDetailsView({
    super.key,
    required this.wallet,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WalletDetailsViewState();
}

class _WalletDetailsViewState extends ConsumerState<WalletDetailsView> {
  @override
  Widget build(BuildContext context) {
    final walletNameController = useTextEditingController(
      text: widget.wallet.walletName,
    );
    // final initialBalanceController = useTextEditingController(
    //   text: widget.wallet.walletBalance.toStringAsFixed(2),
    // );

    final wallets = ref.watch(userWalletsProvider);

    //get walletId when walletName is 'Personal'
    // final walletId;
    // if (widget.wallet.walletName == 'Personal') {
    final walletId =
        widget.wallet.walletName == 'Personal' ? widget.wallet.walletId : null;
    // }

    // final isCreateButtonEnabled = useState(false);

    // useEffect(
    //   () {
    //     void listener() {
    //       // isCreateButtonEnabled.value = walletNameController.text.isNotEmpty;
    //       // walletNameController.text = widget.wallet.walletName;
    //       // initialBalanceController.text = widget.wallet.initialBalance;
    //     }

    //     walletNameController.addListener(listener);
    //     // initialBalanceController.addListener(listener);

    //     return () {
    //       walletNameController.removeListener(listener);
    //       // initialBalanceController.removeListener(listener);
    //     };
    //   },
    //   [
    //     walletNameController,
    //     // initialBalanceController,
    //   ],
    // );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Details'),
        actions: [
          // if (widget.wallet.walletName == 'Personal')
          //   walletId = widget.wallet.walletId;

          if (wallets.valueOrNull != null && widget.wallet.walletId != walletId)
            IconButton(
              icon: const Icon(Icons.delete_rounded),
              onPressed: () async {
                final deletePost = await const DeleteDialog(
                  titleOfObjectToDelete: 'Wallet',
                ).present(context);
                if (deletePost == null) return;

                if (deletePost) {
                  await ref
                      .read(deleteWalletProvider.notifier)
                      .deleteWallet(walletId: widget.wallet.walletId);
                  if (mounted) {
                    Navigator.of(context).maybePop();
                  }
                }
              },
            ),
        ],
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 32.0),
                        child: SizedBox(
                          width: 5,
                          child: Icon(
                            AppIcons.wallet,
                            color: AppColors.mainColor1,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: widget.wallet.walletName == 'Personal'
                              ? Text(
                                  widget.wallet.walletName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.mainColor1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : TextField(
                                  controller: walletNameController,
                                  decoration: const InputDecoration(
                                    labelText: Strings.walletName,
                                  ),
                                  autofocus: true,
                                ),
                        ),
                      ),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     const Padding(
                  //       padding: EdgeInsets.only(left: 16.0, right: 32.0),
                  //       child: SizedBox(
                  //         width: 5,
                  //         child: Icon(
                  //           Icons.money_rounded,
                  //           color: AppColors.mainColor1,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: TextField(
                  //           controller: initialBalanceController,
                  //           keyboardType: TextInputType.number,
                  //           decoration: const InputDecoration(
                  //             labelText: Strings.walletBalance,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 32.0),
                        child: SizedBox(
                          width: 5,
                          child: Icon(
                            Icons.category_rounded,
                            color: AppColors.mainColor1,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const [
                              Expanded(
                                child: Text(
                                  'Visible Categories',
                                  style: TextStyle(
                                    color: AppColors.mainColor1,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Text(
                                'XX',
                                style: TextStyle(
                                  color: AppColors.mainColor1,
                                  fontSize: 16,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: AppColors.mainColor1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 32.0),
                        child: SizedBox(
                          width: 5,
                          child: Icon(
                            Icons.people_alt_rounded,
                            color: AppColors.mainColor1,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const [
                              Expanded(
                                child: Text(
                                  'Share Wallet with Other People',
                                  style: TextStyle(
                                    color: AppColors.mainColor1,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: AppColors.mainColor1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FullWidthButtonWithText(
                        text: Strings.saveChanges,
                        onPressed: () {
                          _updateNewWalletController(
                            walletNameController,
                            // initialBalanceController,
                            ref,
                          );
                        },
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(16.0),
                    //   child: SizedBox(
                    //     width: double.infinity,
                    //     child: ElevatedButton(
                    //       style: ElevatedButton.styleFrom(
                    //         fixedSize: const Size(80, 55),
                    //         backgroundColor: AppColors.mainColor1,
                    //         foregroundColor: AppColors.white,
                    //         shape: const RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.all(
                    //             Radius.circular(25),
                    //           ),
                    //         ),
                    //       ),
                    //       onPressed: () {
                    //         _updateNewWalletController(
                    //           walletNameController,
                    //           initialBalanceController,
                    //           ref,
                    //         );
                    //       },
                    //       child: const FullWidthButtonWithText(
                    //         text: Strings.saveChanges,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateNewWalletController(
    TextEditingController nameController,
    // TextEditingController balanceController,
    WidgetRef ref,
  ) async {
    final userId = ref.read(userIdProvider);
    if (userId == null) {
      return;
    }
    // if (balanceController.text.isEmpty) {
    //   balanceController.text = '0.00';
    // }
    final isUpdated =
        await ref.read(updateWalletProvider.notifier).updateWallet(
              walletId: widget.wallet.walletId,
              walletName: nameController.text,
              // walletBalance: double.parse(balanceController.text),
            );
    if (isUpdated && mounted) {
      nameController.clear();
      // balanceController.clear();
      // Navigator.of(context).pop();
      // Future.delayed(const Duration(seconds: 2), () {
      //   Navigator.of(context).maybePop();
      // });
      Navigator.of(context).maybePop();
    }
  }

  Iterable<Wallet> _getWallets() {
    final wallets = ref.watch(userWalletsProvider);
    return wallets.value ?? [];
  }
}
