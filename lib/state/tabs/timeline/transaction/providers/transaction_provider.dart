import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/tabs/timeline/transaction/notifiers/transaction_state_notifier.dart';

final transactionTypeProvider =
    StateNotifierProvider<TransactionTypeNotifier, int>(
        (ref) => TransactionTypeNotifier());

// final selectedTransactionTypeProvider = StateProvider<int>(
//   (ref) => ,
// );