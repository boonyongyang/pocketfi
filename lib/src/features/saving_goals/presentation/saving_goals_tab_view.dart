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

class SavingGoalsTabView extends ConsumerWidget {
  const SavingGoalsTabView({super.key});

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
    double savedPercentage;
    if (totalSavingGoalsAmount == 0) {
      savedPercentage = 0.0;
    } else {
      savedPercentage = (totalSavedAmount / totalSavingGoalsAmount);
    }
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
                            Text(
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
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: LinearProgressIndicator(
                                minHeight: 25,
                                value: totalSavedAmount == 0 &&
                                        totalSavingGoalsAmount == 0
                                    ? 0
                                    : savedPercentage,
                                backgroundColor: Colors.grey[300],
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.subColor1,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                top: 4.0,
                                bottom: 4.0,
                              ),
                              child: Text(
                                  '${(savedPercentage * 100).toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    color: savedPercentage * 100 > 16
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
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
                                  builder: (_) => const SavingGoalDetailView(),
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
            },
          ),
        ],
      ),
    );
  }
}
