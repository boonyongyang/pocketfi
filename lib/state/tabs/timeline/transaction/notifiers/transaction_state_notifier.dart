import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/tabs/timeline/transaction/models/transaction_type.dart';

final selectedTransactionTypeProvider = StateProvider<TransactionType>(
  (ref) => TransactionType.expense,
);

class TransactionNotifier extends StateNotifier<List<TransactionType>> {
  // final _transaction = const
  TransactionNotifier() : super(TransactionType.values) {}
}
