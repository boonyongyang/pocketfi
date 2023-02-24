import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pocketfi/views/constants/app_colors.dart';

class TransactionDatePicker extends StatefulWidget {
  const TransactionDatePicker({Key? key}) : super(key: key);

  @override
  TransactionDatePickerState createState() => TransactionDatePickerState();
}

class TransactionDatePickerState extends State<TransactionDatePicker> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  void _updateSelectedDate(DateTime selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
    });
  }

  void _selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      _updateSelectedDate(selectedDate);
    }
  }

  void _previousDay() {
    // HapticFeedback.vibrate();
    // ios haptic feedback
    HapticFeedback.lightImpact();
    HapticFeedback.selectionClick();

    // SystemSound.play(SystemSoundType.click);
    _updateSelectedDate(_selectedDate.subtract(const Duration(days: 1)));
  }

  void _nextDay() {
    // HapticFeedback.vibrate();
    HapticFeedback.heavyImpact();

    _updateSelectedDate(_selectedDate.add(const Duration(days: 1)));
  }

  String get _selectedDateText {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    if (_selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day) {
      return 'Today';
    } else if (_selectedDate.year == yesterday.year &&
        _selectedDate.month == yesterday.month &&
        _selectedDate.day == yesterday.day) {
      return 'Yesterday';
    } else if (_selectedDate.year == tomorrow.year &&
        _selectedDate.month == tomorrow.month &&
        _selectedDate.day == tomorrow.day) {
      return 'Tomorrow';
    } else {
      return DateFormat('EEE, d MMM').format(_selectedDate);
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
            color: AppSwatches.mainColor1,
          ),
          // const Text('Date: '),
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
