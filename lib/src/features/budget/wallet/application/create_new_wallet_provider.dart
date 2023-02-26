import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/budget/wallet/data/create_new_wallet_notifier.dart';
import 'package:pocketfi/src/constants/typedefs.dart';

final createNewWalletProvider =
    StateNotifierProvider<CreateNewWalletNotifier, IsLoading>(
  (ref) => CreateNewWalletNotifier(),
);
