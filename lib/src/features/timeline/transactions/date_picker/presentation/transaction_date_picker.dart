import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/timeline/transactions/date_picker/application/selected_date_notifier.dart';
import 'package:pocketfi/src/utils/haptic_feedback_service.dart';

class TransactionDatePicker extends ConsumerStatefulWidget {
  const TransactionDatePicker({Key? key}) : super(key: key);

  @override
  TransactionDatePickerState createState() => TransactionDatePickerState();
}

class TransactionDatePickerState extends ConsumerState<TransactionDatePicker> {
  // late DateTime _selectedDate;

  // @override
  // void initState() {
  //   super.initState();
  //   _selectedDate = DateTime.now();
  // }

  // void _updateSelectedDate(DateTime selectedDate) {
  //   setState(() {
  //     _selectedDate = selectedDate;
  //   });
  // }

  // void _selectDate(BuildContext context) async {
  //   final selectedDate = await showDatePicker(
  //     context: context,
  //     initialDate: _selectedDate,
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //   );
  //   if (selectedDate != null) {
  //     _updateSelectedDate(selectedDate);
  //   }
  // }

  // void _previousDay() {
  //   HapticFeedbackService.lightImpact();
  //   _updateSelectedDate(_selectedDate.subtract(const Duration(days: 1)));
  // }

  // void _nextDay() {
  //   HapticFeedbackService.lightImpact();
  //   _updateSelectedDate(_selectedDate.add(const Duration(days: 1)));
  // }

  // String get _selectedDateText {
  //   final now = DateTime.now();
  //   final yesterday = DateTime(now.year, now.month, now.day - 1);
  //   final tomorrow = DateTime(now.year, now.month, now.day + 1);

  //   if (_selectedDate.year == now.year &&
  //       _selectedDate.month == now.month &&
  //       _selectedDate.day == now.day) {
  //     return 'Today';
  //   } else if (_selectedDate.year == yesterday.year &&
  //       _selectedDate.month == yesterday.month &&
  //       _selectedDate.day == yesterday.day) {
  //     return 'Yesterday';
  //   } else if (_selectedDate.year == tomorrow.year &&
  //       _selectedDate.month == tomorrow.month &&
  //       _selectedDate.day == tomorrow.day) {
  //     return 'Tomorrow';
  //   } else {
  //     return DateFormat('EEE, d MMM').format(_selectedDate);
  //   }
  // }

  void _selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: ref.read(selectedDateProvider),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      ref.read(selectedDateProvider.notifier).updateSelectedDate(selectedDate);
      // TODO: if selectedDate is in the future, make it a scheduled transaction
    }
  }

  void _previousDay() {
    HapticFeedbackService.lightImpact();
    ref.read(selectedDateProvider.notifier).previousDay();
  }

  void _nextDay() {
    HapticFeedbackService.lightImpact();
    ref.read(selectedDateProvider.notifier).nextDay();
  }

  String get _selectedDateText {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    final selectedDate = ref.watch(selectedDateProvider);

    if (selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day) {
      return 'Today';
    } else if (selectedDate.year == yesterday.year &&
        selectedDate.month == yesterday.month &&
        selectedDate.day == yesterday.day) {
      return 'Yesterday';
    } else if (selectedDate.year == tomorrow.year &&
        selectedDate.month == tomorrow.month &&
        selectedDate.day == tomorrow.day) {
      return 'Tomorrow';
    } else {
      return DateFormat('EEE, d MMM').format(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today_rounded,
            color: AppColors.mainColor1,
          ),
          TextButton(
            onPressed: () => _selectDate(context),
            child: Text(
              _selectedDateText,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: _previousDay,
            icon: const Icon(Icons.arrow_back_ios_rounded),
          ),
          const SizedBox(width: 8.0),
          IconButton(
            onPressed: _nextDay,
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
      ),
    );
  }
}
