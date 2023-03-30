import 'package:hooks_riverpod/hooks_riverpod.dart';

// class SelectedDateNotifier extends StateNotifier<DateTime> {
//   SelectedDateNotifier(date) : super(date);

//   // DateTime get datee => date;

//   void updateSelectedDate(DateTime selectedDate) {
//     state = selectedDate;
//   }

//   void previousDay() {
//     state = state.subtract(const Duration(days: 1));
//   }

//   DateTime nextDay() {
//     return state = state.add(const Duration(days: 1));
//   }

//   void resetDate() {
//     // state = date;
//   }
// }

// final selectedDateProvider =
//     StateNotifierProvider.family<SelectedDateNotifier, DateTime, DateTime>(
//         (ref, date) => SelectedDateNotifier(date));

// ******** THIS IS NOTHING?
// class DateNotifier extends StateNotifier<DateTime> {
//   DateNotifier(date) : super(date ?? DateTime.now()) {
//     // if the date is null, return DateTime.now(), else date=date
//     // state = date ?? DateTime.now();
//   }

//   void updateSelectedDate(DateTime selectedDate) {
//     state = selectedDate;
//   }

//   void previousDay() {
//     state = state.subtract(const Duration(days: 1));
//   }

//   void nextDay() {
//     state = state.add(const Duration(days: 1));
//   }

//   DateTime setTransactionDate(DateTime date) {
//     return state = date;
//   }
// }

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
