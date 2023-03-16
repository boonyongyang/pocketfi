import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet.dart';

final getWalletWithWalletId =
    StreamProvider.family<Wallet, String>((ref, walletId) {
  final controller = StreamController<Wallet>();

  final sub = FirebaseFirestore.instance
      .collectionGroup(FirebaseCollectionName.wallets)
      .where(FirebaseFieldName.walletId, isEqualTo: walletId)
      .limit(1)
      .snapshots();

  sub.listen((snapshot) {
    final document = snapshot.docs;
    final wallet = document.map((doc) => Wallet(doc.data())).first;
    controller.sink.add(wallet);
  });

  return controller.stream;
});

// class GetWalletWithWalletId extends StateNotifier<bool> {
//   GetWalletWithWalletId() : super(false);

//   // final Reader read;

//   Future<Wallet> getWalletWithWalletId(String walletId) async {
//     final sub = FirebaseFirestore.instance
//         .collectionGroup(FirebaseCollectionName.wallets)
//         .where(FirebaseFieldName.walletId, isEqualTo: walletId)
//         .limit(1)
//         .snapshots();

//     sub.listen((snapshot) {
//       final document = snapshot.docs;
//       final wallet = document.map((doc) => Wallet(doc.data())).first;
//       return wallet;
//     });
//   }
//   return wallet;
// }
