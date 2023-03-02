import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_collection_name.dart';
import 'package:pocketfi/src/constants/firebase_field_name.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet.dart';

final defaultWallet = Wallet(
  const {
    // FirebaseFieldName.walletId: 'default',
    FirebaseFieldName.walletName: 'Personal',
    // FirebaseFieldName.userId: ,
    // FirebaseFieldName.createdAt: DateTime.now(),
  },
);

final selectedWalletProvider = StateProvider<Wallet?>(
  (ref) {
    // FIXME wallet should not be null, it should always return a default 'Personal' wallet
    // FIXME if there is no wallet, it should return a default wallet

    final wallets = ref.read(userWalletsProvider).value;
    // final wallets = getWallets();
    if (wallets == null) {
      return null;
    }
    return wallets.first;
  },
);

// Iterable<Wallet> getWallets() {
//   return null;
// }

// final selectedWalletProvider = StateProvider.family<Wallet, Wallet>(
//   (ref, defaultWallet) => defaultWallet,
// );

final userWalletsProvider = StreamProvider.autoDispose<Iterable<Wallet>>((ref) {
  final userId = ref.watch(userIdProvider);
  final controller = StreamController<Iterable<Wallet>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.users)
      .doc(userId)
      .collection(FirebaseCollectionName.wallets)
      .where(FirebaseFieldName.userId, isEqualTo: userId)

      // .orderBy(FirebaseFieldName.createdAt,
      //     descending: true) //TODO: need to test
      .snapshots()
      .listen((snapshot) {
    final document = snapshot.docs;
    final wallets = document.map(
      (doc) => Wallet(doc.data()),
    );

// .where((doc) => !doc.metadata.hasPendingWrites)
    controller.sink.add(wallets);
    // display how many wallet in firebase
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
});
