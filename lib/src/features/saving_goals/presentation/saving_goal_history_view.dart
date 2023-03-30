import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/saving_goals/domain/saving_goal.dart';

class SavingGoalHistoryView extends ConsumerWidget {
  SavingGoal savingGoal;
  SavingGoalHistoryView({
    super.key,
    required this.savingGoal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remainingAmount =
        savingGoal.savingGoalAmount - savingGoal.savingGoalSavedAmount;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
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
              // height: MediaQuery.of(context).size.height * 0.35,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Amount Saved',
                          style: TextStyle(
                            // fontSize: 20,
                            color: AppColors.mainColor1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          savingGoal.savingGoalSavedAmount.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 30,
                            color: AppColors.mainColor2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'MYR',
                          style: TextStyle(
                            // fontSize: 20,
                            color: AppColors.mainColor1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          'Amount Left to Save',
                          style: TextStyle(
                            // fontSize: 20,
                            color: AppColors.mainColor1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          remainingAmount.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 30,
                            color: AppColors.mainColor2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'MYR',
                          style: TextStyle(
                            // fontSize: 20,
                            color: AppColors.mainColor1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // list view of history
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
