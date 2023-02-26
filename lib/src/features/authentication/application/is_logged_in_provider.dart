import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/authentication/domain/auth_result.dart';

import 'auth_state_provider.dart';

final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.result == AuthResult.success;
});
