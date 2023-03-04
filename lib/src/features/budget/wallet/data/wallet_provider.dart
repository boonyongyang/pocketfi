import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_collection_name.dart';
import 'package:pocketfi/src/constants/firebase_field_name.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet_id.dart';

// final walletIdProvider = StreamProvider.autoDispose<Iterable<WalletId>>((ref) {
//   final controller = StreamController<Iterable<WalletId>>();

//   return controller.stream;
// });

final getWalletFromWalletIdProvider =
    StreamProvider.family.autoDispose<Wallet, String>((
  ref,
  String walletId,
) {
  // create a stream controller
  final controller = StreamController<Wallet>();

  final userId = ref.watch(userIdProvider);

  // create a subscription to the user collection
  final sub = FirebaseFirestore.instance
      // get the users collection
      .collection(FirebaseCollectionName.users)
      .doc(userId)
      .collection(FirebaseCollectionName.wallets)
      // .doc(walletId.toString())
      .where(
        FirebaseFieldName.walletId,
        isEqualTo: walletId,
      )
      // get the first document
      .limit(1)
      .snapshots()
      .listen(
    (snapshot) {
      // get the first document
      final doc = snapshot.docs.first;
      // get the json data of the document (Map)
      final json = doc.data();
      // deserialize the json to a UserInfoModel
      final wallet = Wallet(
        json,
      );
      controller.add(wallet);
      // controller.sink.add(userInfoModel); // this works too
    },
  );

  // dispose the subscription when the provider is disposed.
  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});

// final getWalletFromWalletIdProvider =
//     FutureProvider.family<Wallet, String>((ref, walletId) async {
//   final userId = ref.watch(userIdProvider);

//   final snapshot = await FirebaseFirestore.instance
//       .collection(FirebaseCollectionName.users)
//       .doc(userId)
//       .collection(FirebaseCollectionName.wallets)
//       .where(
//         FirebaseFieldName.walletId,
//         isEqualTo: walletId,
//       )
//       .limit(1)
//       .get();

//   final doc = snapshot.docs.first;
//   final json = doc.data();
//   final wallet = Wallet(json);

//   return wallet;
// });
