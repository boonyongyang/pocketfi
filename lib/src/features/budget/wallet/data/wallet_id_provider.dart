import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet_id.dart';

final walletIdProvider = StreamProvider.autoDispose<Iterable<WalletId>>((ref) {
  final controller = StreamController<Iterable<WalletId>>();

  return controller.stream;
});
