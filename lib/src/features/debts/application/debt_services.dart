import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/debts/data/debt_repository.dart';
import 'package:pocketfi/src/features/debts/data/debt_payment_repository.dart';
import 'package:pocketfi/src/features/debts/domain/debt.dart';

//* Debts
final debtProvider = StateNotifierProvider<DebtNotifier, IsLoading>(
  (ref) => DebtNotifier(),
);

//* Debt Payments (Paid)
final debtPaymentProvider =
    StateNotifierProvider<DebtPaymentNotifier, IsLoading>(
  (ref) => DebtPaymentNotifier(),
);

//* Selected Debts (not working)
final selectedDebtProvider = StateNotifierProvider<SelectedDebtNotifier, Debt?>(
  (_) => SelectedDebtNotifier(null),
);

class SelectedDebtNotifier extends StateNotifier<Debt?> {
  SelectedDebtNotifier(Debt? debt) : super(debt);

  void setSelectedDebt(Debt debt, WidgetRef ref) {
    state = debt;
  }
}

// final debtMonthlyAmortization = Provider((ref) => ({
//       required double totalDebtAmount,
//       required double minPaymentPerMonth,
//       required double annualInterestRate,
//       required DateTime createdAt,
//     }) {
//       // Your provider logic here
//       int createdMonth = createdAt.month;

//       double endBalance = totalDebtAmount;
//       double monthlyInterestRate = (annualInterestRate / 100) / 12;
//       double interest = 0;
//       double principle = 0;
//       int months = createdMonth - 1;

//       List<Map<String, dynamic>> tableData = [];

//       while (endBalance > 0 && endBalance > minPaymentPerMonth) {
//         interest = endBalance * monthlyInterestRate;
//         endBalance = endBalance + interest - minPaymentPerMonth;
//         principle = minPaymentPerMonth - interest;
//         months++;

//         // int month = createdMonth + months;
//         // if (month > 12) {
//         //   month -= 12;
//         // }
//         String monthName = DateFormat('MMM yyyy').format(
//           DateTime(createdAt.year, months),
//         );
//         Map<String, dynamic> rowData = {
//           'month': monthName,
//           'interest': interest.toStringAsFixed(2),
//           'principle': principle.toStringAsFixed(2),
//           'endBalance': endBalance.toStringAsFixed(2),
//         };

//         tableData.add(rowData);
//       }

//       interest = endBalance * monthlyInterestRate;
//       principle = endBalance;
//       endBalance = 0.00;
//       months++;

//       String monthName = DateFormat('MMM yyyy').format(
//         DateTime(createdAt.year, months),
//       );

//       Map<String, dynamic> rowData = {
//         'month': monthName,
//         'interest': interest.toStringAsFixed(2),
//         'principle': principle.toStringAsFixed(2),
//         'endBalance': endBalance.toStringAsFixed(2),
//       };

//       tableData.add(rowData);

//       return tableData;
//     });
// // a normal provider of List<Map<String, dynamic>>

