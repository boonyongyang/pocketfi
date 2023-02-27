import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/timeline/transactions/data/transaction_type_notifier.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';

final transactionTypeProvider =
    StateNotifierProvider<TransactionTypeNotifier, TransactionType>(
        (ref) => TransactionTypeNotifier());

final createNewTransactionProvider =
    StateNotifierProvider<CreateNewTransactionNotifier, IsLoading>(
        (ref) => CreateNewTransactionNotifier());
