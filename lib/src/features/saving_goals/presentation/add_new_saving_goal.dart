import 'dart:io';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/wallets/application/wallet_services.dart';
import 'package:pocketfi/src/features/wallets/domain/wallet.dart';
import 'package:pocketfi/src/features/wallets/presentation/select_wallet_dropdownlist.dart';
import 'package:pocketfi/src/features/saving_goals/application/saving_goal_services.dart';

class AddNewSavingGoal extends StatefulHookConsumerWidget {
  const AddNewSavingGoal({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddNewSavingGoalState();
}

class _AddNewSavingGoalState extends ConsumerState<AddNewSavingGoal> {
  DateTimeRange? _selectedDateRange;
  @override
  Widget build(BuildContext context) {
    final savingGoalName = useTextEditingController();
    final savingGoalAmount = useTextEditingController();

    final isCreateButtonEnabled = useState(false);

    // final selectedWallet = ref.watch(selectedWalletForSavingGoalProvider);
    final selectedWallet = ref.watch(selectedWalletProvider);

    useEffect(() {
      void listener() {
        isCreateButtonEnabled.value =
            savingGoalName.text.isNotEmpty && savingGoalAmount.text.isNotEmpty;
      }

      savingGoalAmount.addListener(listener);
      savingGoalName.addListener(listener);

      return () {
        savingGoalAmount.removeListener(listener);
        savingGoalName.removeListener(listener);
      };
    }, [
      savingGoalName,
      savingGoalAmount,
    ]);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Create New Saving Goal'),
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 250,
                    child: AutoSizeTextField(
                      autofocus: true,
                      textAlign: TextAlign.center,
                      enableInteractiveSelection: false,
                      showCursor: false,
                      keyboardType: Platform.isIOS
                          ? const TextInputType.numberWithOptions(
                              decimal: true,
                            )
                          : TextInputType.number,
                      // This regex for only amount (price). you can create your own regex based on your requirement
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,4}'))
                      ],
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: Strings.zeroAmount,
                      ),
                      controller: savingGoalAmount,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainColor2,
                      ),
                    ),
                  ),
                ),
                const Text(
                  'MYR',
                  style: TextStyle(
                    color: AppColors.mainColor1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 32.0),
                      child: SizedBox(
                        width: 5,
                        child: FaIcon(
                          FontAwesomeIcons.piggyBank,
                          color: AppColors.mainColor1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: savingGoalName,
                          decoration: const InputDecoration(
                            labelText: 'Saving Goal Name',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 16.0,
                        right: 32.0,
                      ),
                      child: SizedBox(
                        width: 5,
                        child: Icon(
                          Icons.date_range,
                          color: AppColors.mainColor1,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _selectedDateRange == null
                            ? TextButton(
                                onPressed: dateRangePicker,
                                child: const Text(
                                  'Select a Date Range',
                                  style: TextStyle(),
                                ),
                              )
                            : TextButton(
                                onPressed: dateRangePicker,
                                child: const Text(
                                  'Selected Date Range',
                                  style: TextStyle(),
                                ),
                              ),
                        _selectedDateRange != null
                            ? Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8.0,
                                      bottom: 8.0,
                                    ),
                                    child: Text(
                                      '${DateFormat('d MMM yyyy').format(_selectedDateRange!.start)} to ${DateFormat('d MMM yyyy').format(_selectedDateRange!.end)}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ],
                ),

                // wallet
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
                    Padding(
                        padding: EdgeInsets.only(
                          left: 8.0,
                          right: 16.0,
                          bottom: 8.0,
                        ),
                        child: SelectWalletDropdownList()),
                  ],
                ),
              ],
            ),
          ),
          FullWidthButtonWithText(
              text: Strings.createNewSavingGoal,
              onPressed: isCreateButtonEnabled.value
                  ? () async {
                      _createSavingGoalController(
                        savingGoalName,
                        savingGoalAmount,
                        _selectedDateRange!.start,
                        _selectedDateRange!.end,
                        selectedWallet!,
                        ref,
                      );
                    }
                  : null),
        ],
      ),
    );
  }

  Future<void> _createSavingGoalController(
    TextEditingController savingGoalName,
    TextEditingController savingGoalAmount,
    DateTime startDate,
    DateTime dueDate,
    Wallet selectedWallet,
    WidgetRef ref,
  ) async {
    final userId = ref.watch(userIdProvider);
    final isCreated =
        await ref.read(savingGoalProvider.notifier).addNewSavingGoal(
              savingGoalName: savingGoalName.text,
              savingGoalAmount: double.parse(savingGoalAmount.text),
              walletId: selectedWallet.walletId,
              userId: userId!,
              dueDate: dueDate,
              startDate: startDate,
            );

    if (isCreated && mounted) {
      savingGoalName.clear();
      savingGoalAmount.clear();
      Navigator.of(context).pop();
    }
  }

  void dateRangePicker() async {
    DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      currentDate: DateTime.now(),
      saveText: 'Done',
    );

    if (result != null) {
      debugPrint(result.start.toString());
      setState(() {
        _selectedDateRange = result;
      });
    }
  }
}
