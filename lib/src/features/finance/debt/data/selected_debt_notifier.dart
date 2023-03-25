import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/finance/debt/domain/debt.dart';

class SelectedDebtNotifier extends StateNotifier<Debt?> {
  SelectedDebtNotifier(Debt? debt) : super(debt);

  void setSelectedDebt(Debt debt, WidgetRef ref) {
    state = debt;
  }
}
