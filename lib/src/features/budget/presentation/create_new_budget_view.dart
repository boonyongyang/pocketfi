import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/budget/application/create_new_budget_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/data/user_wallets_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet.dart';
import 'package:pocketfi/src/features/budget/wallet/presentation/select_wallet_dropdownlist.dart';

class CreateNewBudgetView extends StatefulHookConsumerWidget {
  const CreateNewBudgetView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateNewBudgetViewState();
}

class _CreateNewBudgetViewState extends ConsumerState<CreateNewBudgetView> {
  @override
  Widget build(BuildContext context) {
    final budgetNameController = useTextEditingController();
    final amountController = useTextEditingController();

    final isCreateButtonEnabled = useState(false);

    useEffect(
      () {
        void listener() {
          isCreateButtonEnabled.value = budgetNameController.text.isNotEmpty &&
              amountController.text.isNotEmpty;
        }

        budgetNameController.addListener(listener);
        amountController.addListener(listener);

        return () {
          budgetNameController.removeListener(listener);
          amountController.removeListener(listener);
        };
      },
      [
        budgetNameController,
        amountController,
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.createNewBudget),
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
                  children: const [
                    Padding(
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
                        padding: EdgeInsets.only(
                          left: 8.0,
                          right: 16.0,
                          // top: 16.0,
                          bottom: 8.0,
                        ),
                        child: SelectWalletDropdownList()),
                  ],
                ),
              ],
            ),
          ),
          FullWidthButtonWithText(
              text: Strings.createNewBudget,
              onPressed: isCreateButtonEnabled.value
                  ? () async {
                      _createNewWalletController(
                        budgetNameController,
                        amountController,
                        ref,
                      );
                    }
                  : null),
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
        await ref.read(createNewBudgetProvider.notifier).createNewBudget(
              userId: userId,
              budgetName: nameController.text,
              budgetAmount: double.parse(balanceController.text),
              // walletId: '2023-02-27T21:08:26.256268',
            );
    if (isCreated && mounted) {
      nameController.clear();
      balanceController.clear();
      // Navigator.of(context).pop();
      // Beamer.of(context).beamBack();
      Navigator.of(context).maybePop();
    }
  }

  // Iterable<Wallet> _getWallets() {
  //   final wallets = ref.watch(userWalletsProvider);
  //   return wallets.valueOrNull ?? [];
  // }
}
