import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/authentication/data/auth_state_notifier.dart';
import 'package:pocketfi/src/features/authentication/domain/auth_state.dart';

// create auth StateNotifierProvider
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (_) => AuthStateNotifier(),
);
