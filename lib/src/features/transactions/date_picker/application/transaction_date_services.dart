import 'package:hooks_riverpod/hooks_riverpod.dart';

// * this is for NEW TransactionDatePicker
final transactionDateProvider =
    StateNotifierProvider<TransactionDateNotifier, DateTime>(
  (ref) => TransactionDateNotifier(),
);

class TransactionDateNotifier extends StateNotifier<DateTime> {
  TransactionDateNotifier() : super(DateTime.now());

  void setDate(DateTime date) {
    state = date;
  }
}

// * this is for Overview Month Selection for month only
final overviewMonthProvider =
    StateNotifierProvider<OverviewMonthNotifier, DateTime>(
  (ref) => OverviewMonthNotifier(),
);

class OverviewMonthNotifier extends StateNotifier<DateTime> {
  OverviewMonthNotifier() : super(DateTime.now());

  void setMonth(DateTime date) {
    state = date;
  }

  resetMonth() {
    state = DateTime.now();
  }
}

// * this is for
// final getDateProvider =
//     StateNotifierProvider.family<DateNotifier, DateTime, DateTime?>(
//         (ref, date) {
//   return DateNotifier(date);
// });

// final selectedDateProvider = StateNotifierProvider<DateNotifier, DateTime>(
//   (ref) => DateNotifier(null),
// );
