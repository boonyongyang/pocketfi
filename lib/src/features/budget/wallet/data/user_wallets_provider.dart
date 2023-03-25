import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/shared_and_user_wallet.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/shared_wallet.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet.dart';

final selectedWalletProvider = StateProvider.autoDispose<Wallet?>(
  (ref) {
    final wallets = ref.watch(userWalletsProvider).value;
    if (wallets == null) {
      debugPrint('wallets is null');
      return null;
    }
    debugPrint('wallets is ${wallets.last.walletName}');

    // get the latest transaction to see which wallet was used, then return that wallet
    // check the transaction createdAt date to compare which is the newest transaction and belongs to which wallet collection,
    // then return that wallet
    // FIXME this is not the best way to do it, it should be done in the backend

    return wallets.last;
  },
);

final selectedWalletForBudgetProvider = StateProvider.autoDispose<Wallet?>(
  (ref) {
    final wallets = ref.watch(userWalletsProvider).value;
    if (wallets == null) {
      debugPrint('wallets is null');
      return null;
    }
    debugPrint('wallets is ${wallets.last.walletName}');

    // get the latest transaction to see which wallet was used, then return that wallet
    // check the transaction createdAt date to compare which is the newest transaction and belongs to which wallet collection,
    // then return that wallet
    // FIXME this is not the best way to do it, it should be done in the backend

    return wallets.first;
  },
);
final selectedWalletForDebtProvider = StateProvider.autoDispose<Wallet?>(
  (ref) {
    final wallets = ref.watch(userWalletsProvider).value;
    if (wallets == null) {
      debugPrint('wallets is null');
      return null;
    }
    debugPrint('wallets is ${wallets.last.walletName}');

    // get the latest transaction to see which wallet was used, then return that wallet
    // check the transaction createdAt date to compare which is the newest transaction and belongs to which wallet collection,
    // then return that wallet
    // FIXME this is not the best way to do it, it should be done in the backend

    return wallets.first;
  },
);

// final selectedUserProvider =
//     StateProvider.autoDispose<Map<UserInfoModel, bool>>(
//   (ref) {
//     final users = ref.watch(usersListProvider).value;
//     final userList = ref.watch(usersListProvider).value;
//     Map<dynamic, bool> userMap = {};
//     userList?.forEach((element) {
//       userMap[element] = false;
//     });
//     // if (users == null) {
//     //   debugPrint('users is null');
//     //   return null;
//     // }

//     // debugPrint('wallets is ${users.last.displayName}');
//     debugPrint(userMap.toString());

//     // get the latest transaction to see which wallet was used, then return that wallet
//     // check the transaction createdAt date to compare which is the newest transaction and belongs to which wallet collection,
//     // then return that wallet
//     // FIXME this is not the best way to do it, it should be done in the backend

//     return userMap.map((key, value) => MapEntry(key as UserInfoModel, !value));
//   },
// );

final userWalletsProvider = StreamProvider.autoDispose<Iterable<Wallet>>((ref) {
  final userId = ref.watch(userIdProvider);
  final controller = StreamController<Iterable<Wallet>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.users)
      .doc(userId)
      .collection(FirebaseCollectionName.wallets)
      .where(FirebaseFieldName.userId, isEqualTo: userId)
      .orderBy(FirebaseFieldName.createdAt, descending: false)
      .snapshots()
      .listen((snapshot) {
    final document = snapshot.docs;
    final wallets = document.where((doc) => !doc.metadata.hasPendingWrites).map(
          (doc) => Wallet(doc.data()),
        );
    // .where((doc) => !doc.metadata.hasPendingWrites)
    controller.sink.add(wallets);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
});

// final userSharedWalletsProvider =
//     StreamProvider.autoDispose<Iterable<SharedWallet>>((ref) {
//   final controller = StreamController<Iterable<SharedWallet>>();
//   final userId = ref.watch(userIdProvider);

//   final sub = FirebaseFirestore.instance
//       .collection(FirebaseCollectionName.users)
//       .doc(userId)
//       .collection(FirebaseCollectionName.wallets)
//       .where(FirebaseFieldName.userId, isEqualTo: userId)
//       .snapshots()
//       .listen((snapshot) {
//     final document = snapshot.docs;
//     final sharedWallets = document.map(
//       (doc) => SharedWallet.fromJson(
//         map: doc.data(),
//       ),
//     );
//     // .where((doc) => !doc.metadata.hasPendingWrites)
//     controller.sink.add(sharedWallets);
//   });

//   ref.onDispose(() {
//     sub.cancel();
//     controller.close();
//   });
//   return controller.stream;
// });

final allWalletsProvider =
    StreamProvider.autoDispose<Iterable<SharedAndUserWallets>>((ref) {
  final controller = StreamController<Iterable<SharedAndUserWallets>>();

  Iterable<Wallet>? wallets;
  Iterable<SharedWallet>? sharedWallets;

  void notify() {
    final outputWallets = wallets;
    if (outputWallets == null) {
      return;
    }
    final outputSharedWallets = sharedWallets;
    if (outputSharedWallets == null) {
      return;
    }

    final result = SharedAndUserWallets(
      wallets: outputWallets,
      sharedWallets: outputSharedWallets,
    );

    controller.sink.add([result]);
  }

  final walletSub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.wallets)
      .snapshots()
      .listen((snapshot) {
    final document = snapshot.docs;
    wallets = document.map(
      (doc) => Wallet(
        doc.data(),
      ),
    );
    notify();
    // .where((doc) => !doc.metadata.hasPendingWrites)
  });

  final sharedWalletSub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.sharedWallets)
      .snapshots()
      .listen((snapshot) {
    if (snapshot.docs.isEmpty) {
      sharedWallets = [];
      notify();
      return;
    }
    final document = snapshot.docs;
    sharedWallets = document.map(
      (doc) => SharedWallet.fromJson(
        map: doc.data(),
      ),
    );
    notify();
    // .where((doc) => !doc.metadata.hasPendingWrites)
  });

  // final sub = FirebaseFirestore.instance
  //     .collection(FirebaseCollectionName.wallets)
  //     .snapshots()
  //     .listen((snapshot) {
  //   final document = snapshot.docs;
  //   final sharedWallets = document.map(
  //     (doc) => SharedAndUserWallets.fromJson(
  //       map: doc.data(),
  //     ),
  //   );
  //   // .where((doc) => !doc.metadata.hasPendingWrites)
  //   controller.sink.add(sharedWallets);
  // });

  ref.onDispose(() {
    // sub.cancel();
    walletSub.cancel();
    sharedWalletSub.cancel();
    controller.close();
  });
  return controller.stream;
});
