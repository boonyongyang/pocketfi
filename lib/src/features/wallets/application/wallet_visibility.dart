import 'dart:collection' show UnmodifiableMapView, HashMap;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/wallets/data/wallet_repository.dart';
import 'package:pocketfi/src/features/wallets/domain/wallet.dart';

class WalletVisibilityNotifier extends StateNotifier<Map<Wallet, bool>> {
  WalletVisibilityNotifier(Map<Wallet, bool> walletVisibility)
      : super(walletVisibility);

  void toggleVisibility(Wallet wallet) {
    final existingValue = state[wallet] ?? true;
    state = UnmodifiableMapView(Map.from(state)..[wallet] = !existingValue);
  }
}

final walletVisibilityProvider =
    StateNotifierProvider<WalletVisibilityNotifier, Map<Wallet, bool>>((ref) {
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
