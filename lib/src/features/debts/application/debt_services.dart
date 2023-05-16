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
