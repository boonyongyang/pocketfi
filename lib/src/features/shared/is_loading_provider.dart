import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/authentication/application/auth_state_provider.dart';
import 'package:pocketfi/src/features/bills/application/bill_services.dart';
import 'package:pocketfi/src/features/budgets/application/budget_services.dart';
import 'package:pocketfi/src/features/debts/application/debt_services.dart';
import 'package:pocketfi/src/features/saving_goals/application/saving_goal_services.dart';
import 'package:pocketfi/src/features/transactions/application/transaction_services.dart';
import 'package:pocketfi/src/features/wallets/application/wallet_services.dart';

// create isLoadingProvider
// this will be used to check if authentication state is loading (boolean)
final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  final isProcessingWallet = ref.watch(walletProvider);
  final isProcessingBudget = ref.watch(budgetProvider);
  final isProcessingDebt = ref.watch(debtProvider);
  final isProcessingSavingGoal = ref.watch(savingGoalProvider);
  final isProcessingTransaction = ref.watch(transactionProvider);
  final isProcessingBill = ref.watch(billProvider);

  return authState.isLoading ||
      isProcessingWallet ||
      isProcessingBudget ||
      isProcessingDebt ||
      isProcessingSavingGoal ||
      isProcessingTransaction ||
      isProcessingBill;
});
