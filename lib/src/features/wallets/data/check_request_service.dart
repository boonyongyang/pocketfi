import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/authentication/domain/collaborators_info.dart';
import 'package:pocketfi/src/features/wallets/domain/shared_wallet.dart';
import 'package:pocketfi/src/features/wallets/domain/wallet.dart';
import 'package:pocketfi/src/features/wallets/domain/wallet_payload.dart';

class CheckRequestNotifier extends StateNotifier<bool> {
  CheckRequestNotifier() : super(false);

  Future<void> updateStatus(
    String status,
    String currentUserId,
    String inviteeId,
    String walletId,
  ) async {
    final walletDocRef = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.wallets)
        .doc(walletId);

    final walletDocSnapshot = await walletDocRef.get();

    if (!walletDocSnapshot.exists) {
      // Handle the case where the wallet document doesn't exist
      return;
    }

    var collaborators =
        walletDocSnapshot.data()![FirebaseFieldName.collaborators] as List;
    for (var i = 0; i < collaborators.length; i++) {
      if (collaborators[i][FirebaseFieldName.userId] == currentUserId &&
          collaborators[i][FirebaseFieldName.status] == 'pending') {
        // Update the status in the collaborators list
        collaborators[i][FirebaseFieldName.status] = status;

        // Update the Firestore document with the updated collaborators list
        await walletDocRef
            .update({FirebaseFieldName.collaborators: collaborators});
        break;
      }
    }
  }

  Future<bool> addSharedWalletToCollaborator({
    required String currentUserId,
    required String walletId,
    required String walletName,
    required String ownerId,
    required String ownerName,
    required String? ownerEmail,
    required DateTime? createdAt,
  }) async {
    final payload = SharedWallet(
      walletId: walletId,
      walletName: walletName,
      userId: currentUserId,
      ownerId: ownerId,
      ownerName: ownerName,
      ownerEmail: ownerEmail!,
      createdAt: createdAt,
    ).toJson();
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.wallets)
          .doc(walletId)
          .set(payload);

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<void> removeCollaborator({
    required String currentUserId,
    required String inviteeId,
    required String walletId,
    required String collaboratorUserId,
    required String collaboratorUserName,
    required String collaboratorUserEmail,
  }) async {
    debugPrint('currentUserId: $currentUserId');
    debugPrint('inviteeId: $inviteeId');
    debugPrint('walletId: $walletId');
    debugPrint('currentUserName: $collaboratorUserName');
    debugPrint('currentUserEmail: $collaboratorUserEmail');
    final walletDocRef = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.wallets)
        .doc(walletId);
    final walletDocSnapshot = await walletDocRef.get();
    if (!walletDocSnapshot.exists) {
      //TODO: Handle the case where the wallet document doesn't exist
      return;
    }
    var collaborators =
        walletDocSnapshot.data()![FirebaseFieldName.collaborators] as List;
    for (var i = 0; i < collaborators.length; i++) {
      if (collaborators[i][FirebaseFieldName.userId] == collaboratorUserId) {
        collaborators.removeAt(i);
        final payload = WalletPayload(
          walletId: walletId,
          walletName: walletDocSnapshot.data()![FirebaseFieldName.walletName],
          userId: currentUserId,
          ownerId: inviteeId,
          ownerEmail: walletDocSnapshot.data()![FirebaseFieldName.ownerEmail],
          ownerName: walletDocSnapshot.data()![FirebaseFieldName.ownerName],
          createdAt:
              walletDocSnapshot.data()![FirebaseFieldName.createdAt].toDate(),
          collaborators:
              collaborators.map((e) => CollaboratorsInfo.fromJson(e)).toList(),
        );
        await FirebaseFirestore.instance
            .collection(FirebaseCollectionName.wallets)
            .doc(walletId)
            .set(payload);
        break;
      }
    }
  }

  Future<bool> removeSharedWalletFromCollaborator({
    required String collaboratorUserId,
    required String walletId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.wallets)
          .doc(walletId)
          .delete();

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}

final checkRequestProvider =
    StateNotifierProvider.autoDispose<CheckRequestNotifier, bool>(
  (ref) => CheckRequestNotifier(),
);

final getPendingRequestProvider = StreamProvider.autoDispose<Iterable>((ref) {
  final controller = StreamController<Iterable>();
  final currentUserId = ref.watch(userIdProvider);

  final querySnapshot = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.wallets)
      .snapshots()
      .listen((snapshot) {
    final docs = snapshot.docs;
    final pendingRequest = docs.where((doc) {
      final collaborators = doc.data()[FirebaseFieldName.collaborators];
      return collaborators != null &&
          (collaborators as List).any((collaborator) =>
              collaborator[FirebaseFieldName.userId] == currentUserId &&
              collaborator[FirebaseFieldName.status] == 'pending');
    }).map((doc) => Wallet.fromJson(
          doc.data(),
        ));

    controller.add(pendingRequest);
  });

  ref.onDispose(() {
    querySnapshot.cancel();
    controller.close();
  });
  return controller.stream;
});
