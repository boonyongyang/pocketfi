import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/saving_goals/application/saving_goal_services.dart';
import 'package:pocketfi/src/features/saving_goals/domain/saving_goal.dart';
import 'package:pocketfi/src/features/saving_goals/presentation/saving_goal_history_view.dart';
import 'package:pocketfi/src/features/saving_goals/presentation/saving_goal_overview.dart';
import 'package:pocketfi/src/features/saving_goals/presentation/update_saving_goal.dart';

class SavingGoalDetailView extends ConsumerWidget {
  // SavingGoal selectedSavingGoal;
  SavingGoalDetailView({
    super.key,
    // required this.selectedSavingGoal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSavingGoal = ref.watch(selectedSavingGoalProvider);
    if (selectedSavingGoal == null) {
      return Container();
    }
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(selectedSavingGoal.savingGoalName),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) => UpdateSavingGoalView(
                        savingGoal: selectedSavingGoal,
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
              const SavingGoalOverviewView(
                  // savingGoal: selectedSavingGoal,
                  ),
              SavingGoalHistoryView(
                  // selectedSavingGoal: selectedSavingGoal,
                  ),
            ],
          ),
        ));
  }
}
