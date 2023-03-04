import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/main.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/common_widgets/dialogs/alert_dialog_model.dart';
import 'package:pocketfi/src/common_widgets/dialogs/delete_dialog.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/budget/application/delete_budget_provider.dart';
import 'package:pocketfi/src/features/budget/application/user_budgets_provider.dart';
import 'package:pocketfi/src/features/budget/domain/budget.dart';
import 'package:pocketfi/src/features/budget/wallet/data/user_wallets_provider.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/add_new_transactions/add_new_transaction.dart';

class BudgetDetailsView extends StatefulHookConsumerWidget {
  final Budget budget;
  const BudgetDetailsView({
    super.key,
    required this.budget,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BudgetDetailsViewState();
}

class _BudgetDetailsViewState extends ConsumerState<BudgetDetailsView> {
  @override
  Widget build(BuildContext context) {
    final budgetNameController = useTextEditingController(
      text: widget.budget.budgetName,
    );
    final amountController = useTextEditingController(
      text: widget.budget.budgetAmount.toStringAsFixed(2),
    );

    final wallets = ref.watch(userWalletsProvider);
    final selectedWallet = ref.watch(selectedWalletProvider);

    final budgets = ref.watch(userBudgetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_rounded),
            onPressed: () async {
              final deletePost = await const DeleteDialog(
                titleOfObjectToDelete: 'Budget',
              ).present(context);
              if (deletePost == null) return;

              if (deletePost) {
                await ref
                    .read(deleteBudgetProvider.notifier)
                    .deleteBudget(budgetId: widget.budget.budgetId);
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
            child: Column(
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
                          controller: budgetNameController,
                          decoration: const InputDecoration(
                            labelText: Strings.budgetName,
                          ),
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
                          Icons.money_rounded,
                          color: AppColors.mainColor1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: Strings.amount,
                            hintText: "0.00",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 16.0,
                        top: 35.0,
                        bottom: 8.0,
                      ),
                      child: DropdownButton<String>(
                        hint: const Text(Strings.currency),
                        value: "MYR",
                        items: <String>[
                          "USD",
                          "EUR",
                          "GBP",
                          "CAD",
                          "AUD",
                          "MYR",
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (_) {},
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
                          AppIcons.wallet,
                          color: AppColors.mainColor1,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Wallets',
                          style: TextStyle(
                            // color: AppSwatches.mainColor2,
                            // fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 16.0,
                          // top: 16.0,
                          bottom: 8.0,
                        ),
                        child: SelectWallet(
                          ref: ref,
                          wallets: wallets.value,
                          selectedWallet: selectedWallet,
                        )
                        // DropdownButton<String>(
                        //   // value: _getWallets().first.walletName,
                        //   items: _getWallets().map((Wallet wallet) {
                        //     return DropdownMenuItem<String>(
                        //       value: wallet.walletName,
                        //       child: Text(wallet.walletName),
                        //     );
                        //   }).toList(),
                        //   onChanged: (_) {},
                        // ),
                        // child: DropdownButton<String>(
                        //   value: "All wallet",
                        //   items: <String>[
                        //     "All wallet",
                        //     "wallet 1",
                        //     "wallet 2",
                        //   ].map<DropdownMenuItem<String>>((String value) {
                        //     return DropdownMenuItem<String>(
                        //       value: value,
                        //       child: Text(value),
                        //     );
                        //   }).toList(),
                        //   onChanged: (_) {},
                        // ),
                        ),
                    // Text(walletChosen.walletName,
                    //     style: const TextStyle(
                    //       fontSize: 15,
                    //     )),
                  ],
                ),
              ],
            ),
          ),
          FullWidthButtonWithText(
            text: Strings.createNewBudget,
            onPressed: () {},
            // isCreateButtonEnabled.value
            //     ? () async {
            //         _createNewWalletController(
            //           budgetNameController,
            //           amountController,
            //           ref,
            //         );
            //       }
            // : null
          ),
        ],
      ),
    );
  }
  // );
}
// }
