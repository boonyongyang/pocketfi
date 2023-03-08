import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/features/authentication/domain/collaborators_info.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet_payload.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/utils/document_id_from_current_date.dart';

class CreateNewWalletNotifier extends StateNotifier<IsLoading> {
  CreateNewWalletNotifier() : super(false);

  set isLoading(bool isLoading) => state = isLoading;

  Future<bool> createNewWallet({
    required String walletName,
    // double? walletBalance = 0.00,
    required UserId userId,
    List<CollaboratorsInfo>? users,
  }) async {
    isLoading = true;

    debugPrint('users in statenotifier: $users');
    final walletId = documentIdFromCurrentDate();

    final payload = WalletPayload(
        walletId: walletId,
        walletName: walletName,
        // walletBalance: walletBalance,
        userId: userId,
        collaborators: users);
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
          .collection(FirebaseCollectionName.users)
          .doc(userId)
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
      return false;
    } finally {
      isLoading = false;
    }
  }
}
