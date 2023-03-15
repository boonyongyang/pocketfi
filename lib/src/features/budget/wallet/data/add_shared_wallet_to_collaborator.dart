import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/authentication/domain/collaborators_info.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/shared_wallet.dart';

import '../../../../constants/firebase_names.dart';

class AddSharedWalletToCollaborator extends StateNotifier<bool> {
  AddSharedWalletToCollaborator() : super(false);

  Future<bool> addSharedWalletToCollaborator({
    required String currentUserId,
    required String walletId,
    required String walletName,
    required String ownerId,
    required String ownerName,
    required String? ownerEmail,
    required DateTime? createdAt,
    List<CollaboratorsInfo>? collaborators,
  }) async {
    final payload = SharedWallet(
      walletId: walletId,
      walletName: walletName,
      userId: currentUserId,
      ownerId: ownerId,
      ownerName: ownerName,
      ownerEmail: ownerEmail!,
      createdAt: createdAt,
      // collaborators: collaborators,
    ).toJson();
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(currentUserId)
          .collection(FirebaseCollectionName.wallets)
          .doc(walletId)
          .set(payload);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

final addSharedWalletToCollaboratorProvider =
    StateNotifierProvider<AddSharedWalletToCollaborator, bool>(
        (ref) => AddSharedWalletToCollaborator());
