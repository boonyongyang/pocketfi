import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/src/features/wallets/domain/shared_wallet.dart';
import 'package:pocketfi/src/features/wallets/domain/wallet.dart';

@immutable
class SharedAndUserWallets {
  final Iterable<Wallet> wallets;
  final Iterable<SharedWallet> sharedWallets;

  const SharedAndUserWallets({
    required this.wallets,
    required this.sharedWallets,
  });

  @override
  bool operator ==(covariant SharedAndUserWallets other) =>
      // runtimeType == other.runtimeType &&
      const IterableEquality().equals(wallets, other.wallets) &&
      const IterableEquality().equals(sharedWallets, other.sharedWallets);

  @override
  int get hashCode => Object.hashAll([
        wallets,
        sharedWallets,
      ]);
}
