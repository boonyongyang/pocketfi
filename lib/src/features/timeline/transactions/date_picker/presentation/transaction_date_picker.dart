import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/timeline/transactions/date_picker/application/selected_date_notifier.dart';
import 'package:pocketfi/src/utils/haptic_feedback_service.dart';

class TransactionDatePicker extends ConsumerStatefulWidget {
  TransactionDatePicker({
    Key? key,
    this.date,
  }) : super(key: key);
  DateTime? date;

  @override
  TransactionDatePickerState createState() => TransactionDatePickerState();
}

class TransactionDatePickerState extends ConsumerState<TransactionDatePicker> {
  void _selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: ref.read(getDateProvider(widget.date)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      ref
          .read(getDateProvider(widget.date).notifier)
          .updateSelectedDate(selectedDate);
      // TODO: if selectedDate is in the future, make it a scheduled transaction
    }
  }

  void _previousDay() {
    HapticFeedbackService.lightImpact();
    ref.read(getDateProvider(widget.date).notifier).previousDay();
    debugPrint('prev: ${ref.read(getDateProvider(widget.date))}');
  }

  void _nextDay() {
    HapticFeedbackService.lightImpact();

    ref.read(getDateProvider(widget.date).notifier).nextDay();
    debugPrint('next: ${ref.read(getDateProvider(widget.date))}');
    debugPrint(widget.date.toString());
  }

  String get _selectedDateText {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    final selectedDate = ref.watch(getDateProvider(widget.date));

    // final test = ref
    //     .read(getDateProvider(widget.date).notifier)
    //     .setTransactionDate(selectedDate);

    // final DateTime selectedDate;

    // if (widget.date == null) {
    // selectedDate = ref.watch(selectedDateProvider(null));
    // } else {
    // final selectedDate = ref.watch(selectedDateProvider(widget.date));
    // }

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

// class TransactionDatePicker extends ConsumerStatefulWidget {
//   const TransactionDatePicker({
//     Key? key,
//     this.date,
//   }) : super(key: key);
//   final DateTime? date;

//   @override
//   TransactionDatePickerState createState() => TransactionDatePickerState();
// }

// class TransactionDatePickerState extends ConsumerState<TransactionDatePicker> {
//   void _selectDate(BuildContext context) async {
//     final selectedDate = await showDatePicker(
//       context: context,
//       initialDate: ref.read(getDateProvider),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );

//     if (selectedDate != null) {
//       ref.read(selectedDateProvider.notifier).updateSelectedDate(selectedDate);
//       // TODO: if selectedDate is in the future, make it a scheduled transaction
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     if (widget.date != null) {
//       ref
//           .read(selectedDateProvider.notifier)
//           .updateSelectedDate(widget.date ?? DateTime.now());
//     }
//   }

//   String get _selectedDateText {
//     final now = DateTime.now();
//     final yesterday = DateTime(now.year, now.month, now.day - 1);
//     final tomorrow = DateTime(now.year, now.month, now.day + 1);

//     final selectedDate = ref.watch(selectedDateProvider);

//     if (selectedDate.year == now.year &&
//         selectedDate.month == now.month &&
//         selectedDate.day == now.day) {
//       return 'Today';
//     } else if (selectedDate.year == yesterday.year &&
//         selectedDate.month == yesterday.month &&
//         selectedDate.day == yesterday.day) {
//       return 'Yesterday';
//     } else if (selectedDate.year == tomorrow.year &&
//         selectedDate.month == tomorrow.month &&
//         selectedDate.day == tomorrow.day) {
//       return 'Tomorrow';
//     } else {
//       return DateFormat('EEE, d MMM').format(selectedDate);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         vertical: 12.0,
//       ),
//       child: Row(
//         children: [
//           const Icon(
//             Icons.calendar_today_rounded,
//             color: AppColors.mainColor1,
//           ),
//           TextButton(
//             onPressed: () => _selectDate(context),
//             child: Text(
//               _selectedDateText,
//             ),
//           ),
//           const Spacer(),
//           IconButton(
//             onPressed: () {
//               ref.read(selectedDateProvider.notifier).previousDay();
//               HapticFeedbackService.lightImpact();
//             },
//             icon: const Icon(Icons.arrow_back_ios_rounded),
//           ),
//           const SizedBox(width: 8.0),
//           IconButton(
//             onPressed: () {
//               ref.read(selectedDateProvider.notifier).nextDay();
//               HapticFeedbackService.lightImpact();
//             },
//             icon: const Icon(Icons.arrow_forward_ios_rounded),
//           ),
//         ],
//       ),
//     );
//   }
// }
