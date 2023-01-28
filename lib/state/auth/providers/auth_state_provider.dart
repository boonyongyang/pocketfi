import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/auth/models/auth_state.dart';
import 'package:pocketfi/state/auth/notifiers/auth_state_notifier.dart';

// create auth StateNotifierProvider
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (_) => AuthStateNotifier(),
);
