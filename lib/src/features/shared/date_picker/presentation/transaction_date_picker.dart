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
  @override
  void initState() {
    super.initState();
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
        // ref.read(transactionDateProvider.notifier).setDate(pickedDate);
        HapticFeedbackService.mediumImpact();
        setOrUpdateDate(pickedDate);
        debugPrint('picked: $pickedDate');
        // if selectedDate is in the future, make it a scheduled transaction
      }
    }
  }

  void _previousDay(DateTime selectedDate) {
    HapticFeedbackService.lightImpact();
    final newDate = selectedDate.subtract(const Duration(days: 1));
    // if (isSelectedTransactionNull) {
    //   ref.read(transactionDateProvider.notifier).setDate(newDate);
    // } else {
    //   ref.read(selectedTransactionProvider.notifier).updateDate(newDate, ref);
    // }
    setOrUpdateDate(newDate);
    debugPrint('prev: $newDate');
  }

  void _nextDay(DateTime selectedDate) {
    HapticFeedbackService.lightImpact();
    final newDate = selectedDate.add(const Duration(days: 1));
    // ref.read(transactionDateProvider.notifier).setDate(newDate);
    setOrUpdateDate(newDate);
    debugPrint('next: $newDate');
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
    // if (ref.watch(selectedTransactionProvider) == null) {
    //   return ref.watch(transactionDateProvider);
    // } else {
    //   return ref.watch(selectedTransactionProvider)!.date;
    // }

    return ref.watch(selectedTransactionProvider)?.date ??
        ref.watch(transactionDateProvider);
  }

  String get _selectedDateText {
    // final selectedDate = ref.watch(transactionDateProvider);

    final DateTime selectedDate = getSelectedDate();
    // if (ref.watch(selectedTransactionProvider) == null) {
    //   selectedDate = ref.watch(transactionDateProvider);
    // } else {
    //   selectedDate = ref.watch(selectedTransactionProvider)!.date;
    // }

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
    // final selectedDate = ref.watch(transactionDateProvider);

    final DateTime selectedDate = getSelectedDate();
    // if (ref.watch(selectedTransactionProvider) == null) {
    //   selectedDate = ref.watch(transactionDateProvider);
    // } else {
    //   selectedDate = ref.watch(selectedTransactionProvider)!.date;
    // }

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
