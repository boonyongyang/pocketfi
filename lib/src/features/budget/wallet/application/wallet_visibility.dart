import 'dart:collection' show UnmodifiableMapView, HashMap;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/budget/wallet/data/user_wallets_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet.dart';

class WalletVisibilityNotifier extends StateNotifier<Map<Wallet, bool>> {
  WalletVisibilityNotifier(HashMap<Wallet, bool> walletVisibility)
      : super(walletVisibility);

  void toggleVisibility(Wallet wallet) {
    final existingValue = state[wallet] ?? true;
    state = UnmodifiableMapView(Map.from(state)..[wallet] = !existingValue);
  }
}

final walletVisibilityProvider = StateNotifierProvider.autoDispose<
    WalletVisibilityNotifier, Map<Wallet, bool>>((ref) {
  final allWallets = ref.watch(userWalletsProvider);
  final walletVisibility = HashMap<Wallet, bool>();

  allWallets.when(
    data: (wallets) {
      for (var wallet in wallets) {
        walletVisibility[wallet] = true;
      }
    },
    loading: () {},
    error: (error, stackTrace) {},
  );
  return WalletVisibilityNotifier(walletVisibility);
});
