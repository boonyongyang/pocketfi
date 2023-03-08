import 'dart:collection' show UnmodifiableMapView, HashMap;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/budget/wallet/data/user_wallets_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/data/wallet_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet.dart';
import 'package:pocketfi/src/features/shared/services/shared_preferences_service.dart';

class WalletVisibilityNotifier extends StateNotifier<Map<Wallet, bool>> {
  WalletVisibilityNotifier(Map<Wallet, bool> walletVisibility)
      : super(walletVisibility);

  void toggleVisibility(Wallet wallet) {
    final existingValue = state[wallet] ?? true;
    state = UnmodifiableMapView(Map.from(state)..[wallet] = !existingValue);
  }
}

// final walletVisibilityProvider = StateNotifierProvider.autoDispose<
//     WalletVisibilityNotifier, Map<Wallet, bool>>((ref)  {
//   // final allWallets = ref.watch(userWalletsProvider);
//   // final walletVisibility = HashMap<Wallet, bool>();

//   final getWalletVisibilityStringMap =
//       await SharedPreferencesService.getWalletVisibilitySettings();

//   Map<Wallet, bool> convertMap(Map<String, bool> originalMap) {
//     final convertedMap = <Wallet, bool>{};
//     originalMap.forEach((key, value) {
//       final wallet = ref.watch(getWalletFromWalletIdProvider(key)).value!;

//       convertedMap[wallet] = value;
//     });
//     return convertedMap;
//   }

//   final walletVisibility = convertMap(getWalletVisibilityStringMap);

//   return WalletVisibilityNotifier(walletVisibility);
// });

final walletVisibilityProvider = StateNotifierProvider.autoDispose<
    WalletVisibilityNotifier, Map<Wallet, bool>>((ref) {
  final allWallets = ref.watch(userWalletsProvider);
  final walletVisibility = HashMap<Wallet, bool>();

  Map<Wallet, bool> convertMap(Map<String, bool> originalMap) {
    final convertedMap = <Wallet, bool>{};
    originalMap.forEach((key, value) {
      // final wallet = Wallet(walletId: key);

      final wallet = ref.watch(getWalletFromWalletIdProvider(key)).value!;

      // final wallet = walletFromWalletId.when(
      //   data: (wallet) => wallet,
      //   loading: () => null,
      //   error: (error, stackTrace) => null,
      // );

      convertedMap[wallet] = value;
    });
    return convertedMap;
  }

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


// * future provider

// final walletVisibilityProvider =
//     FutureProvider.autoDispose<Map<String, bool>>((ref) async {
//   final walletVisibilityStringMap =
//       SharedPreferencesService.getWalletVisibilitySettings();

//   Map<Wallet, bool> convertMap(Map<String, bool> originalMap) {
//     final convertedMap = <Wallet, bool>{};
//     originalMap.forEach((key, value) {
//       // final wallet = Wallet(walletId: key);

//       final wallet = ref.watch(getWalletFromWalletIdProvider(key)).value!;

//       // final wallet = walletFromWalletId.when(
//       //   data: (wallet) => wallet,
//       //   loading: () => null,
//       //   error: (error, stackTrace) => null,
//       // );

//       convertedMap[wallet] = value;
//     });
//     return convertedMap;
//   }

//   return walletVisibilityStringMap;
// });
