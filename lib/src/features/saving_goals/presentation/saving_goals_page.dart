import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/saving_goals/application/saving_goal_services.dart';
import 'package:pocketfi/src/features/saving_goals/data/saving_goal_repository.dart';
import 'package:pocketfi/src/features/saving_goals/presentation/add_new_saving_goal.dart';
import 'package:pocketfi/src/features/saving_goals/presentation/saving_goal_detail_view.dart';
import 'package:pocketfi/src/features/saving_goals/presentation/saving_goals_tiles.dart';

class SavingGoalsPage extends ConsumerWidget {
  const SavingGoalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savingGoals = ref.watch(userSavingGoalsProvider);
    final totalSavingGoalsAmount = ref.watch(totalAmountProvider).value;
    final totalSavedAmount = ref.watch(totalSavedAmountProvider).value;
    if (totalSavedAmount == null || totalSavingGoalsAmount == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    final totalAmountLeft = totalSavingGoalsAmount - totalSavedAmount;
    return RefreshIndicator(
      onRefresh: () async {
        ref.refresh(userSavingGoalsProvider);
        return Future.delayed(const Duration(seconds: 1));
      },
      child: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                color: AppColors.mainColor1,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            // Calculation part
                            Text(
                              // 'RM XX.XX',
                              'MYR ${totalSavingGoalsAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppColors.mainColor1,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Calculation part
                            const Text(
                              'Saved',
                              style: TextStyle(
                                color: AppColors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'MYR ${totalSavedAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppColors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Calculation part
                            const Text(
                              'Left',
                              style: TextStyle(
                                color: AppColors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'MYR ${totalAmountLeft.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppColors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: savingGoals.when(data: (savingGoals) {
                      if (savingGoals.isEmpty) {
                        return const SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: EmptyContentsWithTextAnimationView(
                              text: Strings.noSavingGoalsYet),
                        );
                      }
                      return ListView.builder(
                        itemCount: savingGoals.length,
                        itemBuilder: (context, index) {
                          final savingGoal = savingGoals.elementAt(index);
                          return SavingGoalsTiles(
                            savingGoal: savingGoal,
                            onTap: () {
                              ref
                                  .read(selectedSavingGoalProvider.notifier)
                                  .setSelectedSavingGoal(savingGoal, ref);
                              Navigator.of(
                                context,
                                rootNavigator: true,
                              ).push(
                                MaterialPageRoute(
                                  builder: (_) => SavingGoalDetailView(
                                      // savingGoal: savingGoal,
                                      ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }, error: ((error, stackTrace) {
                      return const ErrorAnimationView();
                    }), loading: () {
                      return const LoadingAnimationView();
                    }),
                  ),

                  // const SavingGoalsTiles(
                  //   savingGoalsName: 'Trip ',
                  // ),
                  // const SavingGoalsTiles(
                  //   savingGoalsName: 'Savings ',
                  // ),

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
          FullWidthButtonWithText(
            text: 'Create New Saving Goal',
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => const AddNewSavingGoal(),
                ),
              );

              // context.beamToNamed("createNewBudget");
              // debugPrint('totalAmount: $totalAmount');
            },
            // },
          ),
        ],
      ),
    );
  }
}
