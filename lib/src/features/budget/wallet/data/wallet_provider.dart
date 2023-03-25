import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet_id.dart';

final getWalletFromWalletIdProvider =
    StreamProvider.family.autoDispose<Wallet, String>((
  ref,
  String walletId,
) {
  final controller = StreamController<Wallet>();

  final userId = ref.watch(userIdProvider);
  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.users)
      .doc(userId)
      .collection(FirebaseCollectionName.wallets)
      // .doc(walletId.toString())
      .where(
        FirebaseFieldName.walletId,
        isEqualTo: walletId,
      )
      .limit(1)
      .snapshots()
      .listen(
    (snapshot) {
      final doc = snapshot.docs.first;
      final json = doc.data();
      final wallet = Wallet(
        json,
      );
      controller.add(wallet);
      // controller.sink.add(userInfoModel); // this works too
    },
  );
  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});

Future<Wallet?> getWalletById(String walletId) async {
  try {
    final walletDoc = await FirebaseFirestore.instance
        .collection('wallets')
        .doc(walletId)
        .get();
    if (walletDoc.exists) {
      return Wallet(
        // walletId: walletDoc.id,
        walletDoc.data()!,
      );
    }
    return null;
  } catch (e) {
    debugPrint('Error getting wallet by ID: $e');
    return null;
  }
}
