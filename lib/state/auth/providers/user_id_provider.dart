import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../tabs/timeline/posts/typedefs/user_id.dart';
import 'auth_state_provider.dart';

final userIdProvider = Provider<UserId?>(
  (ref) => ref.watch(authStateProvider).userId,
);
