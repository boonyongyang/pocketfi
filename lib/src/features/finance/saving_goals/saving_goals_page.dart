import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/finance/saving_goals/saving_goals_tiles.dart';

class SavingGoalsPage extends ConsumerWidget {
  const SavingGoalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Total',
                          style: TextStyle(
                            color: AppColors.mainColor1,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        // Calculation part
                        Text(
                          // 'RM XX.XX',
                          'RM XXX.XX',
                          style: TextStyle(
                            color: AppColors.mainColor1,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        // Calculation part
                        Text(
                          'RM XX.XX left',
                          style: TextStyle(
                            color: AppColors.mainColor2,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              const SavingGoalsTiles(
                savingGoalsName: 'Trip ',
              ),
              const SavingGoalsTiles(
                savingGoalsName: 'Savings ',
              ),
              FullWidthButtonWithText(
                text: 'Create New Saving Goal',
                onPressed: () {
                  // context.beamToNamed("createNewBudget");
                  // debugPrint('totalAmount: $totalAmount');
                },
                // },
              ),
              //       Expanded(
              //         flex: 4,
              //         child: budgets.when(data: (budgets) {
              //           if (budgets.isEmpty) {
              //             return const SingleChildScrollView(
              //               physics: AlwaysScrollableScrollPhysics(),
              //               child: EmptyContentsWithTextAnimationView(
              //                   text: Strings.noBudgetsYet),
              //             );
              //           }
              //           return RefreshIndicator(
              //             onRefresh: () async {
              //               ref.refresh(userBudgetsProvider);
              //               return Future.delayed(const Duration(seconds: 1));
              //             },
              //             child: ListView.builder(
              //               itemCount: budgets.length,
              //               itemBuilder: (context, index) {
              //                 final budget = budgets.elementAt(index);
              //                 return BudgetTile(
              //                   budget: budget,
              //                   onTap: () {
              //                     Navigator.push(
              //                       context,
              //                       MaterialPageRoute(
              //                         builder: (_) => BudgetDetailsView(
              //                           budget: budget,
              //                         ),
              //                       ),
              //                     );
              //                   },
              //                 );
              //               },
              //             ),
              //           );
              //         }, error: ((error, stackTrace) {
              //           return const ErrorAnimationView();
              //         }), loading: () {
              //           return const LoadingAnimationView();
              //         }),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
