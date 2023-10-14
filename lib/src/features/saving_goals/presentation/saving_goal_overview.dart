import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/saving_goals/application/saving_goal_services.dart';
import 'package:pocketfi/src/features/saving_goals/domain/saving_goal.dart';

class SavingGoalOverviewView extends StatefulHookConsumerWidget {
  // SavingGoal selectedSavingGoal;
  const SavingGoalOverviewView({
    super.key,
    // required this.selectedSavingGoal,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SavingGoalOverviewViewState();
}

class _SavingGoalOverviewViewState
    extends ConsumerState<SavingGoalOverviewView> {
  @override
  Widget build(BuildContext context) {
    final selectedSavingGoal = ref.watch(selectedSavingGoalProvider);
    // if (selectedSavingGoal == null) {
    //   return Container();
    // }
    var amountToSavePerDay = selectedSavingGoal!.calculateSavingsPerDay();
    var amountToSavePerWeek = selectedSavingGoal.calculateSavingsPerWeek();
    var amountToSavePerMonth = selectedSavingGoal.calculateSavingsPerMonth();
    var daysLeft = selectedSavingGoal.daysLeft();
    var calculateDaysLeft = selectedSavingGoal.calculateDaysLeft();
    debugPrint('calculateDaysLeft: $daysLeft');

    final amountToSave = useTextEditingController();
    final amountToWithdraw = useTextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        // physics: const AlwaysScrollableScrollPhysics(),
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
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                            // calculateDaysLeft.toString(),
                            // calculateDaysLeft > 30 || calculateDaysLeft > 31
                            //     ? '$months months $days days'
                            //     : calculateDaysLeft > 365
                            //         ? '$years years $months months $days days'
                            //         : '$calculateDaysLeft days',
                            daysLeft,
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
                            'MYR ${selectedSavingGoal.savingGoalAmount.toStringAsFixed(2)}',
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
                                .format(selectedSavingGoal.startDate),
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
                                .format(selectedSavingGoal.dueDate),
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
                            'MYR ${selectedSavingGoal.savingGoalSavedAmount.toStringAsFixed(2)}',
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
                            calculateDaysLeft > 7
                                ? 'MYR ${amountToSavePerWeek.toStringAsFixed(2)}/week'
                                : 'MYR 0.00/week',
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
                            calculateDaysLeft > 30 || calculateDaysLeft > 31
                                ? 'MYR ${amountToSavePerMonth.toStringAsFixed(2)}/month'
                                : 'MYR 0.00/month',
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
                                        selectedSavingGoal,
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
                        // if value still 0 show snack bar
                        if (selectedSavingGoal.savingGoalSavedAmount == 0) {
                          Fluttertoast.showToast(
                            msg: 'You have no money to withdraw!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.white,
                            textColor: AppColors.mainColor1,
                            fontSize: 16.0,
                          );
                        } else {
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
                                                selectedSavingGoal
                                                    .savingGoalSavedAmount
                                            ? withdrawal(
                                                amountToWithdraw,
                                                selectedSavingGoal,
                                                ref,
                                              )
                                            : Fluttertoast.showToast(
                                                msg:
                                                    'You do not have enough money to withdraw',
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 2,
                                                backgroundColor: Colors.white,
                                                textColor: AppColors.mainColor1,
                                                fontSize: 16.0,
                                              );
                                        // ScaffoldMessenger.of(context)
                                        //     .showSnackBar(
                                        //     const SnackBar(
                                        //       content: Text(
                                        //         'You do not have enough money to withdraw',
                                        //         textAlign: TextAlign.center,
                                        //       ),
                                        //     ),
                                        //   );
                                      },
                                      child: const Text('Confirm',
                                          style: TextStyle(
                                            color: AppColors.mainColor2,
                                          )),
                                    ),
                                  ],
                                );
                              });
                        }
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
              userId: savingGoal.userId,
              walletId: savingGoal.walletId,
            );

    if (isUpdated && mounted) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: 'Deposit successful!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.white,
        textColor: AppColors.mainColor1,
        fontSize: 16.0,
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Deposit successful!'),
      //   ),
      // );
    }
    if (!isUpdated && mounted) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: 'Deposit failed!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.white,
        textColor: AppColors.mainColor1,
        fontSize: 16.0,
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Deposit failed!'),
      //   ),
      // );
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
              userId: savingGoal.userId,
              walletId: savingGoal.walletId,
            );

    if (isUpdated && mounted) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: 'Withdraw successful!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.white,
        textColor: AppColors.mainColor1,
        fontSize: 16.0,
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Withdraw successful!'),
      //   ),
      // );
    }
    if (!isUpdated && mounted) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: 'Withdraw failed!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.white,
        textColor: AppColors.mainColor1,
        fontSize: 16.0,
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Withdraw failed!'),
      //   ),
      // );
    }
  }
}
