import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet.dart';

@immutable
class WalletId {
  final String walletName;

  const WalletId({
    required this.walletName,
  });
}

Wallet testWallet = Wallet({
  FirebaseFieldName.walletId: 'default',
  FirebaseFieldName.walletName: 'asd',
  FirebaseFieldName.createdAt: Timestamp.now(),
  FirebaseFieldName.userId: '123',
});
