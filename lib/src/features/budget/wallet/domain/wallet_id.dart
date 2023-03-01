import 'package:flutter/foundation.dart' show immutable;

@immutable
class WalletId {
  final String walletName;

  const WalletId({
    required this.walletName,
  });
}
