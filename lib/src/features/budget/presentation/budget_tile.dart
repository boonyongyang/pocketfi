import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/budget/domain/budget.dart';

class BudgetTile extends ConsumerWidget {
  // final double totalBudgetAmount;
  // final double remainingAmount;
  // final String budgetName;
  // final Icon categoryIcon;
  // final Color categoryColor;
  final Budget budget;
  final VoidCallback onTap;
  const BudgetTile({
    super.key,
    required this.budget,
    required this.onTap,

    // required this.totalBudgetAmount,
    // required this.remainingAmount,
    // required this.budgetName,
    // required this.categoryIcon,
    // required this.categoryColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 8.0,
          bottom: 8.0,
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
            padding: const EdgeInsets.all(16.0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Column(
                //   children: [
                //     CircleAvatar(
                //       backgroundColor: categoryColor,
                //       child: categoryIcon,
                //     ),
                //   ],
                // ),
                // const SizedBox(
                //   width: 20,
                // ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            budget.budgetName,
                            style: const TextStyle(
                              color: AppColors.mainColor1,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'RM ${budget.budgetAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: AppColors.mainColor1,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "RM ${budget.usedAmount.toStringAsFixed(2)} left",
                            style: const TextStyle(
                              color: AppColors.mainColor2,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Row
  // column
    // circle avatar
    // Row 
      // food drinks 
      // RM 1200
    //Row 
      // progress bar
    //row 
      //left 