import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/auth/providers/user_id_provider.dart';
import 'package:pocketfi/state/tabs/budget/wallet/provider/create_new_wallet_provider.dart';
import 'package:pocketfi/views/constants/app_colors.dart';
import 'package:pocketfi/views/constants/strings.dart';
import 'package:pocketfi/views/constants/button_widget.dart';

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
    final initialBalanceController = useTextEditingController();

    final isCreateButtonEnabled = useState(false);
    // final request = useState(
    //   RequestForWallets(
    //     userId: widget.userId,
    //   ),
    // );

    // final wallets = ref.watch(userWalletsProvider);

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: walletNameController,
              decoration: const InputDecoration(
                labelText: Strings.walletName,
              ),
              // autofocus: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: initialBalanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: Strings.walletBalance,
              ),
            ),
          ),
          // Expanded(
          //   flex: 1,
          //   child: Align(
          //     alignment: Alignment.bottomCenter,
          //     child:
          Padding(
            padding: const EdgeInsets.all(8.0),
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
              onPressed: isCreateButtonEnabled.value
                  ? () async {
                      // _createNewWalletController(
                      //   walletNameController,
                      //   initialBalanceController,
                      //   ref,
                      // );
                      final userId = ref.read(
                        userIdProvider,
                      );
                      if (userId == null) {
                        return;
                      }
                      final message = walletNameController.text;
                      final amount = initialBalanceController.text;
                      // hook the UI to the imageUploadProvider for uploading the post
                      // hooking the UI to the provider will cause the UI to rebuild
                      final isUploaded = await ref
                          .read(createNewWalletProvider.notifier)
                          .createNewWallet(
                            userId: userId,
                            walletName: message,
                            walletBalance: double.parse(amount),
                          );
                      if (isUploaded && mounted) {
                        // if the post is uploaded, then pop the screen
                        // Navigator.of(context).pop();
                        Beamer.of(context).beamBack();
                      }
                    }
                  : null,
              child: const ButtonWidget(
                text: Strings.createNewWallet,
              ),
            ),
          ),
          // ),
          // ),
        ],
      ),
    );
  }

  Future<void> _createNewWalletController(
    TextEditingController nameController,
    TextEditingController balanceController,
    WidgetRef ref,
  ) async {
    final userId = ref.read(userIdProvider);
    if (userId == null) {
      return;
    }
    if (balanceController.text.isEmpty) {
      balanceController.text = '0.00';
    }
    final isCreated =
        await ref.read(createNewWalletProvider.notifier).createNewWallet(
              userId: userId,
              walletName: nameController.text,
              walletBalance: double.parse(balanceController.text),
            );
    if (isCreated && mounted) {
      nameController.clear();
      balanceController.clear();
      Navigator.of(context).pop();
    }
  }
}
