import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/authentication/domain/collaborators_info.dart';
import 'package:pocketfi/src/features/wallets/data/wallet_repository.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/wallets/domain/wallet.dart';

final walletProvider = StateNotifierProvider<WalletNotifier, IsLoading>(
  (ref) => WalletNotifier(),
);

// * selectedWalletNotifier
final selectedWalletProvider =
    StateNotifierProvider<SelectedWalletNotifier, Wallet?>((ref) =>
        SelectedWalletNotifier(ref.watch(userWalletsProvider).value?.first));

// * SelectedWalletNotifier
class SelectedWalletNotifier extends StateNotifier<Wallet?> {
  SelectedWalletNotifier(Wallet? wallet) : super(wallet);

  void setSelectedWallet(Wallet? wallet) => state = wallet;

  void resetSelectedWallet() => state = null;

  void updateCollaboratorInfoList(
      List<CollaboratorsInfo> newList, WidgetRef ref) {
    Wallet? wallet = ref.watch(selectedWalletProvider);
    if (wallet != null) {
      wallet = wallet.copyWith(collaborators: newList);
      state = wallet;
    }
  }
}
