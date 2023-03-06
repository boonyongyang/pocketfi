import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketfi/src/constants/app_colors.dart';

class AddTransactionDatePicker extends ConsumerStatefulWidget {
  const AddTransactionDatePicker({super.key});

  @override
  AddTransactionDatePickerState createState() =>
      AddTransactionDatePickerState();
}

class AddTransactionDatePickerState
    extends ConsumerState<AddTransactionDatePicker> {
  Future<void> _selectDate(BuildContext context, DateTime initialDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1990),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      ref.read(selectedDateTestProvider.notifier).setDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateTestProvider);

    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final String selectedDateText;

    if (selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day) {
      selectedDateText = 'Today';
    } else if (selectedDate.year == yesterday.year &&
        selectedDate.month == yesterday.month &&
        selectedDate.day == yesterday.day) {
      selectedDateText = 'Yesterday';
    } else if (selectedDate.year == tomorrow.year &&
        selectedDate.month == tomorrow.month &&
        selectedDate.day == tomorrow.day) {
      selectedDateText = 'Tomorrow';
    } else {
      selectedDateText = DateFormat('EEE, d MMM').format(selectedDate);
    }

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
            onPressed: () => _selectDate(context, selectedDate),
            child: Text(
              // DateFormat.yMMMMd().format(selectedDate),
              selectedDateText,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              final newDate = selectedDate.subtract(const Duration(days: 1));
              ref.read(selectedDateTestProvider.notifier).setDate(newDate);
            },
            icon: const Icon(Icons.arrow_back_ios_rounded),
          ),
          const SizedBox(width: 8.0),
          IconButton(
            onPressed: () {
              final newDate = selectedDate.add(const Duration(days: 1));
              ref.read(selectedDateTestProvider.notifier).setDate(newDate);
            },
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
      ),
    );
  }
}

final selectedDateTestProvider =
    StateNotifierProvider<SelectedDateNotifier, DateTime>(
  (ref) => SelectedDateNotifier(),
);

class SelectedDateNotifier extends StateNotifier<DateTime> {
  SelectedDateNotifier() : super(DateTime.now());

  void setDate(DateTime date) {
    state = date;
  }
}
