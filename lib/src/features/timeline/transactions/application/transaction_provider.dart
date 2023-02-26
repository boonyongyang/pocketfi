import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/timeline/transactions/data/transaction_state_notifier.dart';

final transactionTypeProvider =
    StateNotifierProvider<TransactionTypeNotifier, int>(
        (ref) => TransactionTypeNotifier());

// final selectedTransactionTypeProvider = StateProvider<int>(
//   (ref) => ,
// );