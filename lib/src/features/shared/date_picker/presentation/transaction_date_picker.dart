import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/transactions/application/transaction_services.dart';
import 'package:pocketfi/src/features/shared/date_picker/application/date_services.dart';
import 'package:pocketfi/src/utils/haptic_feedback_service.dart';

class TransactionDatePicker extends ConsumerStatefulWidget {
  final DateTime? initialDate;

  const TransactionDatePicker({
    super.key,
    this.initialDate,
  });

  @override
  TransactionDatePickerState createState() => TransactionDatePickerState();
}

class TransactionDatePickerState extends ConsumerState<TransactionDatePicker> {
  // ignore: unused_field
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
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
                setOrUpdateDate(newDate);
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
        setOrUpdateDate(pickedDate);
      }
    }
  }

  void _previousDay(DateTime selectedDate) {
    HapticFeedbackService.lightImpact();
    final newDate = selectedDate.subtract(const Duration(days: 1));
    setOrUpdateDate(newDate);
  }

  void _nextDay(DateTime selectedDate) {
    HapticFeedbackService.lightImpact();
    final newDate = selectedDate.add(const Duration(days: 1));
    setOrUpdateDate(newDate);
  }

  // setOrUpdateDate
  void setOrUpdateDate(DateTime newDate) {
    isSelectedTransactionNull
        ? ref.read(transactionDateProvider.notifier).setDate(newDate)
        : ref
            .read(selectedTransactionProvider.notifier)
            .updateTransactionDate(newDate, ref);
  }

  DateTime getSelectedDate() {
    return ref.watch(selectedTransactionProvider)?.date ??
        ref.watch(transactionDateProvider);
  }

  String get _selectedDateText {
    final DateTime selectedDate = getSelectedDate();
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

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

  bool get isSelectedTransactionNull =>
      (ref.watch(selectedTransactionProvider)?.date == null);

  @override
  Widget build(BuildContext context) {
    final DateTime selectedDate = getSelectedDate();
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.edit_calendar_rounded,
            color: AppColors.mainColor1,
          ),
          const SizedBox(width: 2.0),
          TextButton(
            onPressed: () => _selectDate(context, selectedDate),
            child: Text(
              _selectedDateText,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              _previousDay(selectedDate);
            },
            icon: const Icon(Icons.arrow_back_ios_rounded),
          ),
          const SizedBox(width: 8.0),
          IconButton(
            onPressed: () {
              _nextDay(selectedDate);
            },
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
      ),
    );
  }
}
