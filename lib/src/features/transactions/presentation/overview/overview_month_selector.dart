import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/transactions/date_picker/application/transaction_date_services.dart';
import 'package:pocketfi/src/utils/haptic_feedback_service.dart';

class OverviewMonthSelector extends ConsumerStatefulWidget {
  final void Function(DateTime) onMonthChanged;

  const OverviewMonthSelector({
    Key? key,
    required this.onMonthChanged,
  }) : super(key: key);

  @override
  MonthSelectorState createState() => MonthSelectorState();
}

class MonthSelectorState extends ConsumerState<OverviewMonthSelector> {
  @override
  Widget build(BuildContext context) {
    final currentMonth = ref.watch(overviewMonthProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              HapticFeedbackService.mediumImpact();
              final previousMonth =
                  DateTime(currentMonth.year, currentMonth.month - 1);
              onMonthChanged(previousMonth);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 32.0,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              _selectDate(context, currentMonth);
            },
            child: Text(
              DateFormat('MMMM yyyy').format(currentMonth),
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.mainColor1,
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              HapticFeedbackService.mediumImpact();
              final nextMonth =
                  DateTime(currentMonth.year, currentMonth.month + 1);
              onMonthChanged(nextMonth);
            },
            icon: const Icon(
              Icons.arrow_forward_ios,
              size: 32.0,
            ),
          ),
        ],
      ),
    );
  }

  // * select date using date picker
  Future<void> _selectDate(BuildContext context, DateTime initialDate) async {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return Container(
            height: 300,
            color: AppColors.white,
            child: CupertinoDatePicker(
              initialDateTime: initialDate,
              minimumDate: DateTime(1990),
              maximumDate: DateTime.now().add(const Duration(days: 365)),
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (DateTime newDate) {
                HapticFeedbackService.mediumImpact();
                ref.read(overviewMonthProvider.notifier).setMonth(newDate);
                debugPrint('picked: $newDate');
              },
            ),
          );
        },
      );
    } else {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1990),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
      if (pickedDate != null) {
        HapticFeedbackService.mediumImpact();
        ref.read(overviewMonthProvider.notifier).setMonth(pickedDate);
        debugPrint('picked: $pickedDate');
        // if selectedDate is in the future, make it a scheduled transaction
      }
    }
  }

  void onMonthChanged(DateTime date) {
    ref.read(overviewMonthProvider.notifier).setMonth(date);
  }
}



// class MonthSelector extends StatefulWidget {
//   final Function(DateTime) onMonthChanged;

//   const MonthSelector({Key? key, required this.onMonthChanged})
//       : super(key: key);

//   @override
//   MonthSelectorState createState() => MonthSelectorState();
// }

// class MonthSelectorState extends State<MonthSelector> {
//   late DateTime _currentMonth;

//   @override
//   void initState() {
//     super.initState();
//     _currentMonth = DateTime.now();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         IconButton(
//           icon: const Icon(Icons.chevron_left),
//           onPressed: () {
//             setState(() {
//               _currentMonth =
//                   DateTime(_currentMonth.year, _currentMonth.month - 1);
//             });
//             widget.onMonthChanged(_currentMonth);
//           },
//         ),
//         Text(DateFormat.yMMMM().format(_currentMonth)),
//         IconButton(
//           icon: const Icon(Icons.chevron_right),
//           onPressed: () {
//             setState(() {
//               _currentMonth =
//                   DateTime(_currentMonth.year, _currentMonth.month + 1);
//             });
//             widget.onMonthChanged(_currentMonth);
//           },
//         ),
//       ],
//     );
//   }
// }
