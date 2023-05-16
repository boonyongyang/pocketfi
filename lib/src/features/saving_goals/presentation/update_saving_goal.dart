// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/common_widgets/dialogs/alert_dialog_model.dart';
import 'package:pocketfi/src/common_widgets/dialogs/delete_dialog.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/saving_goals/application/saving_goal_services.dart';
import 'package:pocketfi/src/features/saving_goals/domain/saving_goal.dart';
import 'package:pocketfi/src/features/wallets/data/wallet_repository.dart';

@immutable
class UpdateSavingGoalView extends StatefulHookConsumerWidget {
  final SavingGoal savingGoal;
  const UpdateSavingGoalView({
    super.key,
    required this.savingGoal,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateSavingGoalViewState();
}

class _UpdateSavingGoalViewState extends ConsumerState<UpdateSavingGoalView> {
  DateTimeRange? _selectedDateRange;

  @override
  Widget build(BuildContext context) {
    final savingGoalName = useTextEditingController(
      text: widget.savingGoal.savingGoalName,
    );
    final savingGoalAmount = useTextEditingController(
      text: widget.savingGoal.savingGoalAmount.toStringAsFixed(2),
    );
    final isCreateButtonEnabled = useState(false);
    final wallet = ref.watch(
        getWalletFromWalletIdProvider(widget.savingGoal.walletId.toString()));

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
        title: const Text('Update Saving Goal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_rounded),
            onPressed: () async {
              final deletePost = await const DeleteDialog(
                titleOfObjectToDelete: 'Saving Goal',
              ).present(context);
              if (deletePost == null) return;

              if (deletePost) {
                await ref.read(savingGoalProvider.notifier).deleteSavingGoal(
                      savingGoalId: widget.savingGoal.savingGoalId,
                      walletId: widget.savingGoal.walletId,
                      userId: widget.savingGoal.userId,
                    );
                if (mounted) {
                  Navigator.pop(context);
                  Navigator.pop(context);
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
                        _selectedDateRange != null ||
                                widget.savingGoal.dueDate != null &&
                                    widget.savingGoal.startDate != null
                            ? TextButton(
                                onPressed: dateRangePicker,
                                child: const Text(
                                  'Selected Date Range',
                                  style: TextStyle(
                                      // color: Colors.grey,
                                      ),
                                ),
                              )
                            : TextButton(
                                onPressed: dateRangePicker,
                                child: const Text(
                                  'Select a Date Range',
                                  style: TextStyle(),
                                ),
                              ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                bottom: 8.0,
                              ),
                              child: _selectedDateRange == null &&
                                      widget.savingGoal.dueDate != null &&
                                      widget.savingGoal.startDate != null
                                  ? Text(
                                      '${DateFormat('d MMM yyyy').format(widget.savingGoal.startDate)} to ${DateFormat('d MMM yyyy').format(widget.savingGoal.dueDate)}')
                                  : Text(
                                      '${DateFormat('d MMM yyyy').format(_selectedDateRange!.start)} to ${DateFormat('d MMM yyyy').format(_selectedDateRange!.end)}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                            ),
                          ],
                        )
                      ],
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
                    Text(
                      wallet.when(
                        data: (wallet) {
                          return wallet.walletName;
                        },
                        error: (error, stack) {
                          return error.toString();
                        },
                        loading: () => 'Loading...',
                      ),
                      style: const TextStyle(
                        color: AppColors.mainColor1,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          FullWidthButtonWithText(
            text: Strings.saveChanges,
            onPressed: isCreateButtonEnabled.value
                ? () async {
                    _updateSavingGoalController(
                      savingGoalName,
                      savingGoalAmount,
                      widget.savingGoal,
                      _selectedDateRange == null
                          ? widget.savingGoal.startDate
                          : _selectedDateRange!.start,
                      _selectedDateRange == null
                          ? widget.savingGoal.dueDate
                          : _selectedDateRange!.end,
                      ref,
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Future<void> _updateSavingGoalController(
    TextEditingController savingGoalName,
    TextEditingController savingGoalAmount,
    SavingGoal savingGoal,
    DateTime startDate,
    DateTime dueDate,
    WidgetRef ref,
  ) async {
    final isCreated =
        await ref.read(savingGoalProvider.notifier).updateSavingGoal(
              savingGoalId: savingGoal.savingGoalId,
              userId: savingGoal.userId,
              walletId: savingGoal.walletId,
              savingGoalName: savingGoalName.text,
              savingGoalAmount: double.parse(savingGoalAmount.text),
              startDate: startDate,
              dueDate: dueDate,
            );
    if (isCreated && mounted) {
      savingGoalName.clear();
      savingGoalAmount.clear();
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  void dateRangePicker() async {
    DateTimeRange? result = await showDateRangePicker(
      context: context,
      initialDateRange: _selectedDateRange == null &&
              widget.savingGoal.dueDate != null &&
              widget.savingGoal.startDate != null
          ? DateTimeRange(
              start: widget.savingGoal.startDate,
              end: widget.savingGoal.dueDate,
            )
          : DateTimeRange(
              start: _selectedDateRange!.start, end: _selectedDateRange!.end),
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
