import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/auth/providers/user_id_provider.dart';
import 'package:pocketfi/state/tabs/budget/wallet/models/wallet.dart';
import 'package:pocketfi/state/tabs/budget/wallet/provider/create_new_wallet_provider.dart';
import 'package:pocketfi/state/tabs/budget/wallet/provider/delete_wallet_provider.dart';
import 'package:pocketfi/state/tabs/budget/wallet/provider/update_wallet_provider.dart';
import 'package:pocketfi/views/components/dialogs/alert_dialog_model.dart';
import 'package:pocketfi/views/components/dialogs/delete_dialog.dart';
import 'package:pocketfi/views/constants/app_colors.dart';
import 'package:pocketfi/views/constants/strings.dart';
import 'package:pocketfi/views/constants/button_widget.dart';

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
    final initialBalanceController = useTextEditingController(
      text: widget.wallet.walletBalance.toString(),
    );

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              // initialValue: widget.wallet.walletName,
              controller: walletNameController,
              decoration: const InputDecoration(
                labelText: Strings.walletName,
              ),
              // autofocus: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              // initialValue: widget.wallet.walletBalance.toString(),
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
              onPressed: () {
                _updateNewWalletController(
                  walletNameController,
                  initialBalanceController,
                  ref,
                );
              },
              // isCreateButtonEnabled.value
              //     ? () {
              //         _updateNewWalletController(
              //           walletNameController,
              //           initialBalanceController,
              //           ref,
              //         );
              //       }
              //     : null,
              child: const ButtonWidget(
                text: Strings.saveChanges,
              ),
            ),
          ),
          // ),
          // ),
        ],
      ),
    );
  }

  Future<void> _updateNewWalletController(
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
    final isUpdated =
        await ref.read(updateWalletProvider.notifier).updateWallet(
              walletId: widget.wallet.walletId,
              walletName: nameController.text,
              walletBalance: double.parse(balanceController.text),
            );
    if (isUpdated && mounted) {
      nameController.clear();
      balanceController.clear();
      // Navigator.of(context).pop();
      // Future.delayed(const Duration(seconds: 2), () {
      //   Navigator.of(context).maybePop();
      // });
      Navigator.of(context).maybePop();
    }
  }
}
