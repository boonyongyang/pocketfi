import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/auth/providers/auth_state_provider.dart';
import 'package:pocketfi/state/image_upload/providers/image_uploader_provider.dart';

// create isLoadingProvider
// this will be used to check if authentication state is loading (boolean)
final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  final isUploadingImage = ref.watch(imageUploadProvider);

  return authState.isLoading || isUploadingImage;
});
