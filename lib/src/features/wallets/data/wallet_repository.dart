import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/features/authentication/domain/collaborators_info.dart';
import 'package:pocketfi/src/features/wallets/domain/shared_wallet.dart';
import 'package:pocketfi/src/features/wallets/domain/wallet.dart';
import 'package:pocketfi/src/features/wallets/domain/wallet_payload.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/utils/document_id_from_current_date.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/wallets/domain/shared_and_user_wallet.dart';

final userWalletsProvider = StreamProvider<Iterable<Wallet>>((ref) {
  final userId = ref.watch(userIdProvider);
  final controller = StreamController<Iterable<Wallet>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.wallets)
      .snapshots()
      .listen((snapshot) {
    final document = snapshot.docs;
    final personalWallets = document
        .where(
          (doc) =>
              doc.data()[FirebaseFieldName.userId] == userId &&
              !doc.metadata.hasPendingWrites,
        )
        .map(
          (doc) => Wallet.fromJson(doc.data()),
        );
    final sharedWallets = document.where((doc) {
      final collaborators = doc.data()[FirebaseFieldName.collaborators];
      return collaborators != null &&
          (collaborators as List).any((collaborator) =>
              collaborator[FirebaseFieldName.userId] == userId &&
              collaborator[FirebaseFieldName.status] == 'accepted');
    }).map((doc) => Wallet.fromJson(doc.data()));
    final wallets = [...personalWallets, ...sharedWallets];
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
      (doc) => Wallet.fromJson(
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

final getWalletFromWalletIdProvider = StreamProvider.family<Wallet, String>((
  ref,
  String walletId,
) {
  final controller = StreamController<Wallet>();

  // final userId = ref.watch(userIdProvider);
  final sub = FirebaseFirestore.instance
      // .collection(FirebaseCollectionName.users)
      // .doc(userId)
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
      final wallet = Wallet.fromJson(
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

final getWalletWithWalletId =
    FutureProvider.family<Wallet, String>((ref, walletId) async {
  final snapshot = await FirebaseFirestore.instance
      // .collectionGroup(FirebaseCollectionName.wallets)
      .collection(FirebaseCollectionName.wallets)
      .where(FirebaseFieldName.walletId, isEqualTo: walletId)
      .limit(1)
      .get();

  final document = snapshot.docs;
  final wallet = document.map((doc) => Wallet.fromJson(doc.data())).first;

  return wallet;
});

// get personal wallet by user id
Future<Wallet?> getPersonalWalletByUserId(String userId) async {
  try {
    final walletDoc = await FirebaseFirestore.instance
        .collection('wallets')
        .where('userId', isEqualTo: userId)
        .where('ownerId', isEqualTo: userId)
        .where('walletName', isEqualTo: 'Personal')
        .get();
    if (walletDoc.docs.isNotEmpty) {
      return Wallet.fromJson(
        // walletId: walletDoc.id,
        walletDoc.docs.first.data(),
      );
    }
    return null;
  } catch (e) {
    debugPrint('Error getting wallet by user ID: $e');
    return null;
  }
}

Future<Wallet?> getWalletById(String walletId) async {
  try {
    final walletDoc = await FirebaseFirestore.instance
        .collection('wallets')
        .doc(walletId)
        .get();
    if (walletDoc.exists) {
      return Wallet.fromJson(
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

class WalletNotifier extends StateNotifier<IsLoading> {
  WalletNotifier() : super(false);

  set isLoading(bool isLoading) => state = isLoading;

  Future<bool> addNewWallet({
    required String walletName,
    // double? walletBalance = 0.00,
    required UserId userId,
    required String ownerName,
    required String? ownerEmail,
    List<CollaboratorsInfo>? users,
  }) async {
    isLoading = true;

    final walletId = documentIdFromCurrentDate();

    final payload = WalletPayload(
      walletId: walletId,
      walletName: walletName,
      // walletBalance: walletBalance,
      userId: userId,
      ownerId: userId,
      ownerName: ownerName,
      ownerEmail: ownerEmail,
      collaborators: users,
    );
    // final collaboratorPayload = UserInfoPayload(
    //   userId: users!.userId,
    //   displayName: users.displayName,
    //   email: users.email,
    // );
    debugPrint('walletPayload: $payload');

    try {
      // final wallets = await FirebaseFirestore.instance
      //     .collection(FirebaseCollectionName.users)
      //     .doc(userId)
      //     .collection(FirebaseCollectionName.wallets)
      //     .get();

      // if (wallets.docs.elementAt([FirebaseFieldName.walletName] as int) ==
      //     walletName) {
      //   return false;
      // }

      await FirebaseFirestore.instance
          // .collection(FirebaseCollectionName.users)
          // .doc(userId)
          .collection(FirebaseCollectionName.wallets)
          .doc(walletId)
          .set(payload);

      // await FirebaseFirestore.instance
      //     .collection(FirebaseCollectionName.users)
      //     .doc(userId)
      //     .collection(FirebaseCollectionName.wallets)
      //     .doc(walletId)
      //     .collection(FirebaseCollectionName.collaborators)
      //     .doc(users.userId)
      //     .set(collaboratorPayload);
      return true;
    } catch (e) {
      debugPrint('error in creating new wallet: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<bool> updateWallet({
    required String userId,
    required String walletId,
    required String walletName,
    List<CollaboratorsInfo>? users,
    // required double walletBalance,
  }) async {
    try {
      isLoading = true;
      debugPrint('users: $users');

      // update wallet name in all users
      final query2 = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.wallets)
          .where(FirebaseFieldName.walletId, isEqualTo: walletId)
          .get();

      await query2.then(
        (query2) async {
          for (final doc in query2.docs) {
            if (walletName != doc[FirebaseFieldName.walletName]) {
              await doc.reference.update(
                {
                  FirebaseFieldName.walletName: walletName,
                },
              );
            }
          }
        },
      );

      //update collaborators in owner
      final query3 = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.wallets)
          .doc(walletId);

      final query3Snapshot = await query3.get();

      // var collaborators = query3Snapshot.data()![FirebaseFieldName.collaborators] as List;

      // for (var i = 0; i < collaborators.length; i++) {
      // if (collaborators == []) {
      if (users != query3Snapshot.data()![FirebaseFieldName.collaborators]) {
        await query3.update({
          FirebaseFieldName.collaborators: FieldValue.arrayRemove(
              query3Snapshot.data()![FirebaseFieldName.collaborators]),
        });

        await query3.update({
          FirebaseFieldName.collaborators:
              users?.map((e) => e.toJson()).toList(),
        });
        // final payload = Wallet(
        //   walletId: walletId,
        //   walletName: walletName,
        //   userId: query3Snapshot.data()![FirebaseFieldName.userId],
        //   ownerId: query3Snapshot.data()![FirebaseFieldName.ownerId],
        //   ownerEmail: query3Snapshot.data()![FirebaseFieldName.ownerEmail],
        //   ownerName: query3Snapshot.data()![FirebaseFieldName.ownerName],
        //   // createdAt: query3Snapshot.data()![FirebaseFieldName.createdAt],
        //   collaborators:
        //       users?.map((e) => CollaboratorsInfo.fromJson(e)).toList(),
        // ).toJson();
        // debugPrint(query3Snapshot.data()![FirebaseFieldName.ownerName]);
        // debugPrint(query3Snapshot.data()![FirebaseFieldName.ownerEmail]);

        // await FirebaseFirestore.instance
        //     .collection(FirebaseCollectionName.wallets)
        //     .doc(walletId)
        //     .set(payload);
        // }else{

        // }
      }

      // * update all transactions' walletName in this wallet
      final walletTransactions = FirebaseFirestore.instance
          // .collectionGroup(FirebaseCollectionName.transactions)
          .collection(FirebaseCollectionName.wallets)
          .where(FirebaseFieldName.walletId, isEqualTo: walletId)
          .get();

      await walletTransactions.then((transactions) async {
        for (final doc in transactions.docs) {
          if (walletName != doc[FirebaseFieldName.walletName]) {
            await doc.reference
                .update({FirebaseFieldName.walletName: walletName});
          }
        }
      });

      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<bool> deleteWallet({
    required String walletId,
  }) async {
    try {
      final wallets = await FirebaseFirestore.instance
          // .collection(FirebaseCollectionName.users)
          // .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(FirebaseCollectionName.wallets)
          .get();
      isLoading = true;

      if (wallets.docs.length == 1) {
        return false;
      }

      final query = FirebaseFirestore.instance
          // .collection(FirebaseCollectionName.users)
          // .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(FirebaseCollectionName.wallets)
          .where(FieldPath.documentId, isEqualTo: walletId)
          .limit(1)
          .get();

      await query.then((query) async {
        for (final doc in query.docs) {
          await doc.reference.delete();
        }
      });
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
