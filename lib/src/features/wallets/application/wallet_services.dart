import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/authentication/domain/collaborators_info.dart';
import 'package:pocketfi/src/features/wallets/data/wallet_repository.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:flutter/foundation.dart';
import 'package:pocketfi/src/features/wallets/domain/wallet.dart';

final walletProvider = StateNotifierProvider<WalletNotifier, IsLoading>(
  (ref) => WalletNotifier(),
);

// final selectedWalletProvider = StateProvider.autoDispose<Wallet?>(
//   (ref) {
//     final wallets = ref.watch(userWalletsProvider).value;
//     if (wallets == null) {
//       debugPrint('wallets is null');
//       return null;
//     }
//     debugPrint('wallets is ${wallets.last.walletName}');

//     // get the latest transaction to see which wallet was used, then return that wallet
//     // check the transaction createdAt date to compare which is the newest transaction and belongs to which wallet collection,
//     // then return that wallet
//     // FIXME this is not the best way to do it, it should be done in the backend

//     return wallets.last;
//   },
// );

// * selectedWalletNotifier
final selectedWalletProvider =
    StateNotifierProvider<SelectedWalletNotifier, Wallet?>((ref) =>
        SelectedWalletNotifier(ref.watch(userWalletsProvider).value?.first));

// * SelectedWalletNotifier
class SelectedWalletNotifier extends StateNotifier<Wallet?> {
  SelectedWalletNotifier(Wallet? wallet) : super(wallet);

  void setSelectedWallet(Wallet? wallet) => state = wallet;

  void resetSelectedWalletState(ref) {
    final Wallet? wallet = ref.watch(selectedWalletProvider).state;
    state = wallet;
  }
}

final selectedWalletForBudgetProvider = StateProvider.autoDispose<Wallet?>(
  (ref) {
    final wallets = ref.watch(userWalletsProvider).value;
    if (wallets == null) {
      debugPrint('wallets is null');
      return null;
    }
    debugPrint('wallets is ${wallets.last.walletName}');
    return wallets.first;
  },
);
final selectedWalletForDebtProvider = StateProvider.autoDispose<Wallet?>(
  (ref) {
    final wallets = ref.watch(userWalletsProvider).value;
    if (wallets == null) {
      debugPrint('wallets is null');
      return null;
    }
    debugPrint('wallets is ${wallets.last.walletName}');
    return wallets.first;
  },
);
final selectedWalletForSavingGoalProvider = StateProvider.autoDispose<Wallet?>(
  (ref) {
    final wallets = ref.watch(userWalletsProvider).value;
    if (wallets == null) {
      debugPrint('wallets is null');
      return null;
    }
    debugPrint('wallets is ${wallets.last.walletName}');
    return wallets.first;
  },
);

final selectedUserWalletProvider =
    StateNotifierProvider<SelectedWalletNotifier, Wallet?>(
  (_) => SelectedWalletNotifier(null),
);

class SelectedWalletNotifier extends StateNotifier<Wallet?> {
  SelectedWalletNotifier(Wallet? wallet) : super(wallet);

  void setSelectedWallet(Wallet wallet, WidgetRef ref) {
    state = wallet;
  }

  void updateCollaboratorInfoList(
      List<CollaboratorsInfo> newList, WidgetRef ref) {
    Wallet? wallet = ref.watch(selectedUserWalletProvider);
    if (wallet != null) {
      wallet = wallet.copyWith(collaborators: newList);
      state = wallet;
    }
  }
}
