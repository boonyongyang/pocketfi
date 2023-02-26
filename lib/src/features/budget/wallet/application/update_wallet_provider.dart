import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/budget/wallet/data/update_wallet_notifier.dart';
import 'package:pocketfi/src/features/shared/typedefs/is_loading.dart';

final updateWalletProvider =
    StateNotifierProvider<UpdateWalletStateNotifier, IsLoading>(
  (_) => UpdateWalletStateNotifier(),
);
