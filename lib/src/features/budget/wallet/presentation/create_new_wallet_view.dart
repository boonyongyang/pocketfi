import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/dialogs/alert_dialog_model.dart';
import 'package:pocketfi/src/common_widgets/dialogs/already_exist_dialog.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/application/create_new_wallet_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/data/user_wallets_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet.dart';

class CreateNewWalletView extends StatefulHookConsumerWidget {
  // final String walletId;

  const CreateNewWalletView({
    super.key,
    // required this.walletId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateNewWalletViewState();
}

class _CreateNewWalletViewState extends ConsumerState<CreateNewWalletView> {
  @override
  Widget build(BuildContext context) {
    final walletNameController = useTextEditingController();
    // final initialBalanceController = useTextEditingController();

    final isCreateButtonEnabled = useState(false);
    // final request = useState(
    //   RequestForWallets(
    //     userId: widget.userId,
    //   ),
    // );

    useEffect(
      () {
        void listener() {
          isCreateButtonEnabled.value = walletNameController.text.isNotEmpty;
        }

        walletNameController.addListener(listener);
        // initialBalanceController.addListener(listener);

        return () {
          walletNameController.removeListener(listener);
          // initialBalanceController.removeListener(listener);
        };
      },
      [
        walletNameController,
        // initialBalanceController,
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.createNewWallet),
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            flex: 4,
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
                        child: TextField(
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
                        text: Strings.createNewWallet,
                        onPressed: isCreateButtonEnabled.value
                            ? () async {
                                if (await _checkWalletNameExists(
                                    walletNameController.text)) {
                                  AlreadyExistDialog(
                                    itemName: walletNameController.text,
                                  ).present(context);
                                } else {
                                  _createNewWalletController(
                                    walletNameController,
                                    // initialBalanceController,
                                    ref,
                                  );
                                }
                              }
                            : null),
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
                    //       onPressed: isCreateButtonEnabled.value
                    //           ? () async {
                    //               _createNewWalletController(
                    //                 walletNameController,
                    //                 initialBalanceController,
                    //                 ref,
                    //               );
                    //               // final userId = ref.read(
                    //               //   userIdProvider,
                    //               // );
                    //               // if (userId == null) {
                    //               //   return;
                    //               // }
                    //               // final message = walletNameController.text;
                    //               // final amount = initialBalanceController.text;
                    //               // // hook the UI to the imageUploadProvider for uploading the post
                    //               // // hooking the UI to the provider will cause the UI to rebuild
                    //               // final isUploaded = await ref
                    //               //     .read(createNewWalletProvider.notifier)
                    //               //     .createNewWallet(
                    //               //       userId: userId,
                    //               //       walletName: message,
                    //               //       walletBalance: double.parse(amount),
                    //               //     );
                    //               // if (isUploaded && mounted) {
                    //               //   // if the post is uploaded, then pop the screen
                    //               //   // Navigator.of(context).pop();
                    //               //   Beamer.of(context).beamBack();
                    //               // }
                    //             }
                    //           : null,
                    //       child: const FullWidthButtonWithText(
                    //         text: Strings.createNewWallet,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createNewWalletController(
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
    final isCreated =
        await ref.read(createNewWalletProvider.notifier).createNewWallet(
              userId: userId,
              walletName: nameController.text,
              // walletBalance: double.parse(balanceController.text),
            );
    if (isCreated && mounted) {
      nameController.clear();
      // balanceController.clear();
      // Navigator.of(context).pop();
      // Beamer.of(context).beamBack();
      Navigator.of(context).maybePop();
    }
  }

  Future<bool> _checkWalletNameExists(
    String nameController,
  ) async {
    debugPrint(nameController);
    debugPrint('getWallet: ' + _getWallets().toString());
    for (var wallet in _getWallets()) {
      debugPrint('everywallet: ${wallet.walletName}');
      if (nameController == wallet.walletName) {
        return true;
      }
    }
    return false;
  }

  Iterable<Wallet> _getWallets() {
    final wallets = ref.read(userWalletsProvider);
    return wallets.maybeWhen(orElse: () => [], data: (wallets) => wallets);
  }
}
