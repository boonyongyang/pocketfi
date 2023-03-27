import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/saving_goals/domain/saving_goal.dart';
import 'package:pocketfi/src/features/saving_goals/presentation/saving_goal_history_view.dart';
import 'package:pocketfi/src/features/saving_goals/presentation/update_saving_goal.dart';

class SavingGoalDetailView extends ConsumerWidget {
  SavingGoal savingGoal;
  SavingGoalDetailView({
    super.key,
    required this.savingGoal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Saving Goal'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) => UpdateSavingGoalView(
                        savingGoal: savingGoal,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
              ),
            ],
            bottom: const TabBar(
              indicatorColor: AppColors.mainColor2,
              labelColor: AppColors.mainColor2,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  text: 'Overview',
                ),
                Tab(
                  text: 'History',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              const Center(
                child: Text('Overview'),
              ),
              SavingGoalHistoryView(
                savingGoal: savingGoal,
              ),
            ],
          ),
        ));
  }
}
