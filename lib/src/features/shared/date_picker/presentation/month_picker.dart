import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/shared/date_picker/application/date_services.dart';
import 'package:pocketfi/src/utils/haptic_feedback_service.dart';

class MonthPicker extends ConsumerStatefulWidget {
  const MonthPicker({Key? key}) : super(key: key);

  @override
  MonthSelectorState createState() => MonthSelectorState();
}

class MonthSelectorState extends ConsumerState<MonthPicker> {
  @override
  Widget build(BuildContext context) {
    final currentMonth = ref.watch(overviewMonthProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 10.0),
            IconButton(
              onPressed: () {
                HapticFeedbackService.mediumImpact();
                final previousMonth =
                    DateTime(currentMonth.year, currentMonth.month - 1);
                onMonthChanged(previousMonth);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 24.0,
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
                size: 24.0,
              ),
            ),
            const SizedBox(width: 10.0),
          ],
        ),
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
