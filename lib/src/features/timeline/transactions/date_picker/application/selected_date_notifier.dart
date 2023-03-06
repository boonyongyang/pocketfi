import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';

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

// ********
class DateNotifier extends StateNotifier<DateTime> {
  DateNotifier(date) : super(date ?? DateTime.now()) {
    // if the date is null, return DateTime.now(), else date=date
    // state = date ?? DateTime.now();
  }

  void updateSelectedDate(DateTime selectedDate) {
    state = selectedDate;
  }

  void previousDay() {
    state = state.subtract(const Duration(days: 1));
  }

  void nextDay() {
    state = state.add(const Duration(days: 1));
  }

  DateTime setTransactionDate(DateTime date) {
    return state = date;
  }
}

final getDateProvider =
    StateNotifierProvider.family<DateNotifier, DateTime, DateTime?>(
        (ref, date) {
  return DateNotifier(date);
});

final selectedDateProvider = StateNotifierProvider<DateNotifier, DateTime>(
  (ref) => DateNotifier(null),
);

// final selectedDateProvider = StateProvider<DateTime>((ref) {
//   final date = ref.watch(getDateProvider(null));

// });

// **** fuck

// final selectedDateProvider =
//     StateNotifierProvider<SelectedDateNotifier, DateTime>((ref) {
//   final date = ref.watch(nowDateProvider);
//   return SelectedDateNotifier(date);
// });

// final getDateProvider = Provider<DateTime>((ref) {
//   return ref.watch(selectedDateProvider);
// });

// final nowDateProvider = Provider<DateTime>((ref) {
//   return DateTime.now();
// });

// class SelectedDateNotifier extends StateNotifier<DateTime> {
//   SelectedDateNotifier(DateTime date) : super(date);

//   void updateSelectedDate(DateTime date) {
//     state = date;
//   }

//   void previousDay() {
//     state = state.subtract(const Duration(days: 1));
//   }

//   void nextDay() {
//     state = state.add(const Duration(days: 1));
//   }
// }

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

final selectedTransactionProvider =
    StateNotifierProvider<SelectedTransactionNotifier, Transaction?>(
  (_) => SelectedTransactionNotifier(null),
);

class SelectedTransactionNotifier extends StateNotifier<Transaction?> {
  SelectedTransactionNotifier(Transaction? transaction) : super(transaction);

  void setTransaction(Transaction? transaction) {
    state = transaction;
  }
}
