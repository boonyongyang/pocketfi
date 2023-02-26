import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/budget/wallet/data/delete_wallet_notifier.dart';
import 'package:pocketfi/src/features/shared/typedefs/is_loading.dart';

final deleteWalletProvider =
    StateNotifierProvider<DeleteWalletStateNotifier, IsLoading>(
  (_) => DeleteWalletStateNotifier(),
);
