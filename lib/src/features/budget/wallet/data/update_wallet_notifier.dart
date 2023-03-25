import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/authentication/domain/collaborators_info.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet_payload.dart';

class UpdateWalletStateNotifier extends StateNotifier<IsLoading> {
  UpdateWalletStateNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> updateWallet({
    required String userId,
    required String walletId,
    required String walletName,
    List<CollaboratorsInfo>? users,
    // required double walletBalance,
  }) async {
    try {
      isLoading = true;

      // final query = FirebaseFirestore.instance
      //     .collection(FirebaseCollectionName.users)
      //     .doc(FirebaseAuth.instance.currentUser!.uid)
      //     .collection(FirebaseCollectionName.wallets)
      //     .where(FieldPath.documentId, isEqualTo: walletId)
      //     .limit(1)
      //     .get();

      // // addListener(() {
      // await query.then(
      //   (query) async {
      //     for (final doc in query.docs) {
      //       if (walletName != doc[FirebaseFieldName.walletName]
      //           // || walletBalance != doc[FirebaseFieldName.walletBalance]
      //           ) {
      //         await doc.reference.update(
      //           {
      //             FirebaseFieldName.walletName: walletName,
      //             // FirebaseFieldName.walletBalance: walletBalance,
      //           },
      //         );
      //       }
      //     }
      //   },
      // );
      // update wallet name in all users
      final query2 = FirebaseFirestore.instance
          .collectionGroup(FirebaseCollectionName.wallets)
          .where(FirebaseFieldName.walletId, isEqualTo: walletId)
          .get();

      await query2.then(
        (query2) async {
          for (final doc in query2.docs) {
            if (walletName != doc[FirebaseFieldName.walletName]
                // || walletBalance != doc[FirebaseFieldName.walletBalance]
                ) {
              await doc.reference.update(
                {
                  FirebaseFieldName.walletName: walletName,
                  // FirebaseFieldName.collaborators: users,
                  // FirebaseFieldName.walletBalance: walletBalance,
                },
              );
            }
          }
        },
      );

      //update collaborators in owner
      final query3 = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(FirebaseCollectionName.wallets)
          .doc(walletId);

      final query3Snapshot = await query3.get();

      var collaborators =
          query3Snapshot.data()![FirebaseFieldName.collaborators] as List;

      // for (var i = 0; i < collaborators.length; i++) {
      // if (collaborators == []) {
      if (users != query3Snapshot.data()![FirebaseFieldName.collaborators]) {
        final payload = WalletPayload(
          walletId: walletId,
          walletName: walletName,
          userId: query3Snapshot.data()![FirebaseFieldName.userId],
          ownerId: query3Snapshot.data()![FirebaseFieldName.ownerId],
          ownerEmail: query3Snapshot.data()![FirebaseFieldName.ownerEmail],
          ownerName: query3Snapshot.data()![FirebaseFieldName.ownerName],
          createdAt:
              query3Snapshot.data()![FirebaseFieldName.createdAt].toDate(),
          collaborators: users,
        );
        debugPrint(query3Snapshot.data()![FirebaseFieldName.ownerName]);
        debugPrint(query3Snapshot.data()![FirebaseFieldName.ownerEmail]);
        query3.delete();

        await FirebaseFirestore.instance
            .collection(FirebaseCollectionName.users)
            .doc(userId)
            .collection(FirebaseCollectionName.wallets)
            .doc(walletId)
            .set(payload);
        // }else{

        // }
      }

      // * update all transactions' walletName in this wallet
      final walletTransactions = FirebaseFirestore.instance
          .collectionGroup(FirebaseCollectionName.transactions)
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
}
