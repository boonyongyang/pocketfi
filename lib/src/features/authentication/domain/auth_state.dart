import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/src/features/timeline/posts/domain/typedefs/user_id.dart';
import 'auth_result.dart';

@immutable
class AuthState {
  final AuthResult? result;
  final bool isLoading;
  final UserId? userId;

  const AuthState({
    required this.result,
    required this.isLoading,
    required this.userId,
  });

// set the default values for the AuthState class
  const AuthState.unknown()
      : result = null,
        isLoading = false,
        userId = null;

// returns a new instance of the AuthState class with updated boolean
  AuthState copiedWithIsLoading(bool isLoading) => AuthState(
        result: result,
        isLoading: isLoading,
        userId: userId,
      );

  @override
  bool operator ==(covariant AuthState other) =>
      identical(this, other) ||
      (result == other.result &&
          isLoading == other.isLoading &&
          userId == other.userId);

  @override
  int get hashCode => Object.hash(
        result,
        isLoading,
        userId,
      );
}
