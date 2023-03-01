import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/authentication/application/auth_state_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/application/delete_wallet_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/application/update_wallet_provider.dart';
import 'package:pocketfi/src/features/timeline/transactions/application/transaction_provider.dart';
import 'package:pocketfi/src/features/timeline/transactions/image_upload/application/image_uploader_provider.dart';

// create isLoadingProvider
// this will be used to check if authentication state is loading (boolean)
final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  final isUploadingImage = ref.watch(imageUploadProvider);
  final isUpdatingWallet = ref.watch(updateWalletProvider);
  final isDeletingWallet = ref.watch(deleteWalletProvider);
  final isCreatingTransaction = ref.watch(createNewTransactionProvider);

  return authState.isLoading ||
      isUploadingImage ||
      isUpdatingWallet ||
      isDeletingWallet ||
      isCreatingTransaction;
});
