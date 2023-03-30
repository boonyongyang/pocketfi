import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/saving_goals/application/saving_goal_services.dart';
import 'package:pocketfi/src/features/saving_goals/domain/saving_goal.dart';
import 'package:pocketfi/src/features/saving_goals/presentation/deposit_sheet.dart';

class SavingGoalOverviewView extends StatefulHookConsumerWidget {
  SavingGoal savingGoal;
  SavingGoalOverviewView({
    super.key,
    required this.savingGoal,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SavingGoalOverviewViewState();
}

class _SavingGoalOverviewViewState
    extends ConsumerState<SavingGoalOverviewView> {
  @override
  Widget build(BuildContext context) {
    var amountToSavePerDay = widget.savingGoal.calculateSavingsPerDay();
    var amountToSavePerWeek = widget.savingGoal.calculateSavingsPerWeek();
    var amountToSavePerMonth = widget.savingGoal.calculateSavingsPerMonth();
    var calculateDaysLeft = widget.savingGoal.calculateDaysLeft();
    int years = calculateDaysLeft ~/ 12; // get the number of years
    int months = calculateDaysLeft % 12; // get the remaining months
    int days = calculateDaysLeft % 30; // get the remaining days

    final amountToSave = useTextEditingController();
    final amountToWithdraw = useTextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                bottom: 8.0,
                left: 8.0,
                right: 8.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(3, 6), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                    8.0,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Count Down to Due Date',
                            style: TextStyle(
                              color: AppColors.mainColor1,
                              fontWeight: FontWeight.bold,
                            ),
                            // textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            calculateDaysLeft > 30 || calculateDaysLeft > 31
                                ? '$months months $days days'
                                : calculateDaysLeft > 365
                                    ? '$years years $months months $days days'
                                    : '$calculateDaysLeft days',
                            // widget.debt.debtAmount.toStringAsFixed(2),
                            style: const TextStyle(
                              color: AppColors.mainColor2,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                            // textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                bottom: 8.0,
                left: 8.0,
                right: 8.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(3, 6), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                    16.0,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Saving Amount',
                            style: TextStyle(
                              color: AppColors.mainColor1,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'MYR ${widget.savingGoal.savingGoalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: AppColors.mainColor1,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Start Date',
                            style: TextStyle(
                              color: AppColors.mainColor1,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            DateFormat('d MMM yyyy')
                                .format(widget.savingGoal.startDate),
                            style: const TextStyle(
                              color: AppColors.mainColor1,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Due Date',
                            style: TextStyle(
                              color: AppColors.mainColor1,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            DateFormat('d MMM yyyy')
                                .format(widget.savingGoal.dueDate),
                            style: const TextStyle(
                              color: AppColors.mainColor1,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                bottom: 8.0,
                left: 8.0,
                right: 8.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(3, 6), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                    16.0,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Amount Saved',
                            style: TextStyle(
                              color: AppColors.mainColor1,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'MYR ${widget.savingGoal.savingGoalSavedAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: AppColors.mainColor1,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Amount to Save Per Day',
                            style: TextStyle(
                              color: AppColors.mainColor1,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'MYR ${amountToSavePerDay.toStringAsFixed(2)}/day',
                            style: const TextStyle(
                              color: AppColors.mainColor1,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Amount to Save Per Week',
                            style: TextStyle(
                              color: AppColors.mainColor1,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'MYR ${amountToSavePerWeek.toStringAsFixed(2)}/week',
                            // 'MYR ${(amountToSavePerDay * 7).toStringAsFixed(2)}/week',
                            style: const TextStyle(
                              color: AppColors.mainColor1,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Amount to Save Per Month',
                            style: TextStyle(
                              color: AppColors.mainColor1,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'MYR ${amountToSavePerMonth.toStringAsFixed(2)}/month',
                            style: const TextStyle(
                              color: AppColors.mainColor1,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 0.35, 55),
                        backgroundColor: AppColors.mainColor2,
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Deposit'),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16.0),
                                    bottom: Radius.circular(16.0),
                                  ),
                                ),
                                content: TextField(
                                  controller: amountToSave,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Enter amount',
                                    icon: FaIcon(
                                      FontAwesomeIcons.piggyBank,
                                      color: AppColors.mainColor1,
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
//
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      addDeposit(
                                        amountToSave,
                                        widget.savingGoal,
                                        ref,
                                      );
                                    },
                                    child: const Text('Confirm',
                                        style: TextStyle(
                                          color: AppColors.mainColor2,
                                        )),
                                  ),
                                ],
                              );
                            });
                      },
                      child: const SizedBox(
                        child: Text(
                          'Deposit',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 0.35, 55),
                        backgroundColor: AppColors.mainColor1,
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Withdraw'),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16.0),
                                    bottom: Radius.circular(16.0),
                                  ),
                                ),
                                content: TextField(
                                  controller: amountToWithdraw,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Enter amount',
                                    icon: FaIcon(
                                      FontAwesomeIcons.piggyBank,
                                      color: AppColors.mainColor1,
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      double.parse(amountToWithdraw.text) <=
                                              widget.savingGoal
                                                  .savingGoalSavedAmount
                                          ? withdrawal(
                                              amountToWithdraw,
                                              widget.savingGoal,
                                              ref,
                                            )
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Insufficient Balance'),
                                              ),
                                            );
                                    },
                                    child: const Text('Confirm',
                                        style: TextStyle(
                                          color: AppColors.mainColor2,
                                        )),
                                  ),
                                ],
                              );
                            });
                      },
                      child: const SizedBox(
                        child: Text(
                          'Withdraw',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addDeposit(
    TextEditingController amountToDeposit,
    SavingGoal savingGoal,
    WidgetRef ref,
  ) async {
    final isUpdated =
        await ref.read(savingGoalProvider.notifier).depositSavingGoalAmount(
              savingGoalId: savingGoal.savingGoalId,
              amount: double.parse(amountToDeposit.text),
            );

    if (isUpdated && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Deposit successful!'),
        ),
      );
    }
    debugPrint('isUpdated: $isUpdated');
    if (!isUpdated && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Deposit failed!'),
        ),
      );
    }
  }

  Future<void> withdrawal(
    TextEditingController amountToWithdraw,
    SavingGoal savingGoal,
    WidgetRef ref,
  ) async {
    final isUpdated =
        await ref.read(savingGoalProvider.notifier).withdrawSavingGoalAmount(
              savingGoalId: savingGoal.savingGoalId,
              amount: double.parse(amountToWithdraw.text),
            );

    if (isUpdated && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Withdraw successful!'),
        ),
      );
    }
    debugPrint('isUpdated: $isUpdated');
    if (!isUpdated && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Withdraw failed!'),
        ),
      );
    }
  }
}
