import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/auth/providers/auth_state_provider.dart';
import 'package:pocketfi/state/image_upload/providers/image_uploader_provider.dart';
import 'package:pocketfi/state/tabs/budget/wallet/provider/delete_wallet_provider.dart';
import 'package:pocketfi/state/tabs/budget/wallet/provider/update_wallet_provider.dart';

// create isLoadingProvider
// this will be used to check if authentication state is loading (boolean)
final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  final isUploadingImage = ref.watch(imageUploadProvider);
  final isUpdatingWallet = ref.watch(updateWalletProvider);
  final isDeletingWallet = ref.watch(deleteWalletProvider);

  return authState.isLoading ||
      isUploadingImage ||
      isUpdatingWallet ||
      isDeletingWallet;
});
