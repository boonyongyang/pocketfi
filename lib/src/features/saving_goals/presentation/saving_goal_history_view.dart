import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/saving_goals/application/saving_goal_services.dart';
import 'package:pocketfi/src/features/saving_goals/data/saving_goal_repository.dart';
import 'package:pocketfi/src/features/saving_goals/domain/saving_goal.dart';
import 'package:pocketfi/src/features/saving_goals/domain/saving_goal_history.dart';

class SavingGoalHistoryView extends ConsumerWidget {
  // SavingGoal selectedSavingGoal;
  const SavingGoalHistoryView({
    super.key,
    // required this.selectedSavingGoal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSavingGoal = ref.watch(selectedSavingGoalProvider);
    final remainingAmount = selectedSavingGoal!.savingGoalAmount -
        selectedSavingGoal.savingGoalSavedAmount;
    final savingGoalHistories = ref
        .watch(userSavingGoalsHistoryProvider(selectedSavingGoal.savingGoalId));
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
                          selectedSavingGoal.savingGoalSavedAmount
                              .toStringAsFixed(2),
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Text('test'),
          // list view of history
          savingGoalHistories.when(data: (savingGoalHistories) {
            if (savingGoalHistories.isEmpty) {
              return const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: EmptyContentsWithTextAnimationView(
                    text: Strings.noSavingGoalsHistoryYet),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                ref.refresh(userSavingGoalsHistoryProvider(
                    selectedSavingGoal.savingGoalId));
              },
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: savingGoalHistories.length,
                itemBuilder: (context, index) {
                  final savingGoalHistory =
                      savingGoalHistories.elementAt(index);
                  final isLastSavingGoalForDate = _isLastSavingGoalForDate(
                    index,
                    savingGoalHistory,
                    ref,
                  );
                  return Column(
                    children: [
                      if (isLastSavingGoalForDate)
                        SavingGoalDateRow(
                          date: savingGoalHistory.savingGoalEnterDate,
                          // netAmount: savingGoalHistories[index].netAmount,
                        ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      DateFormat('d MMM yyyy').format(
                                          savingGoalHistory
                                              .savingGoalEnterDate),
                                      style: const TextStyle(
                                        color: AppColors.mainColor1,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Text(
                                      savingGoalHistory.savingGoalStatus ==
                                              SavingGoalStatus.deposit.name
                                          ? Strings.deposit
                                          : Strings.withdraw,
                                      style: const TextStyle(
                                        color: AppColors.mainColor1,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'MYR ${savingGoalHistory.savingGoalEnterAmount.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: savingGoalHistory
                                                    .savingGoalStatus ==
                                                SavingGoalStatus.deposit.name
                                            ? AppColors.green
                                            : AppColors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }, error: ((error, stackTrace) {
            return const ErrorAnimationView();
          }), loading: () {
            return const LoadingAnimationView();
          }),
        ],
      ),
    );
  }

  bool _isLastSavingGoalForDate(
    int index,
    SavingGoalHistory savingGoal,
    WidgetRef ref,
  ) {
    final savingGoalHistories =
        ref.watch(userSavingGoalsHistoryProvider(savingGoal.savingGoalId));

    // Check if the transaction is the last one for its date
    if (index == 0) return true;
    final savingHistory = savingGoalHistories.value;
    final previousSaving = savingHistory?.elementAt(index - 1);
    return !_areDatesEqual(
        savingGoal.savingGoalEnterDate, previousSaving!.savingGoalEnterDate);
  }

  bool _areDatesEqual(DateTime date1, DateTime date2) {
    // Check if two dates are equal
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
    // return date2.isAtSameMomentAs(date1);
  }
}

class SavingGoalDateRow extends StatefulWidget {
  const SavingGoalDateRow({
    super.key,
    required this.date,
    // required this.netAmount,
  });
  final DateTime date;
  // final double netAmount;

  @override
  SavingGoalDateRowState createState() => SavingGoalDateRowState();
}

class SavingGoalDateRowState extends State<SavingGoalDateRow> {
  String get _selectedDateText {
    final DateTime selectedDate = widget.date;

    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    if (selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day) {
      return Strings.today;
    } else if (selectedDate.year == yesterday.year &&
        selectedDate.month == yesterday.month &&
        selectedDate.day == yesterday.day) {
      return Strings.yesterday;
    } else if (selectedDate.year == tomorrow.year &&
        selectedDate.month == tomorrow.month &&
        selectedDate.day == tomorrow.day) {
      return Strings.tomorrow;
    } else {
      return DateFormat('EEE, d MMM').format(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.grey[400],
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _selectedDateText,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
