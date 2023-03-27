import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/authentication/domain/user_info.dart';
import 'package:pocketfi/src/features/wallets/domain/wallet_payload.dart';
import 'package:pocketfi/src/utils/document_id_from_current_date.dart';

@immutable
class UserInfoStorage {
  const UserInfoStorage();
  Future<bool> saveUserInfo({
    required UserId userId,
    required String displayName,
    required String? email,
  }) async {
    try {
      // first check if we have this user's info from before
      final userInfo = await FirebaseFirestore.instance
          .collection(
            FirebaseCollectionName.users,
          )
          .where(
            // where the userId is equal to the userId we passed in
            FirebaseFieldName.userId,
            isEqualTo: userId,
          )
          .limit(1) // limit to 1 result
          .get(); // get the result

      // if we have this user's info from before, update it
      if (userInfo.docs.isNotEmpty) {
        await userInfo.docs.first.reference.update({
          FirebaseFieldName.displayName: displayName,
          FirebaseFieldName.email: email ?? '',
        });
        return true;
      }

      // if we don't have this user's info from before, create it
      final payload = UserInfoPayload(
        userId: userId,
        displayName: displayName,
        email: email,
      );
      final walletId = documentIdFromCurrentDate();
      final walletPayload = WalletPayload(
        walletId: walletId,
        walletName: 'Personal',
        ownerId: userId,
        ownerName: displayName,
        ownerEmail: email ?? '',
        // walletBalance: 0.00,
        userId: userId,
        collaborators: const [],
      );
      // TODO: Add category payload, differentiate default and custom

      await FirebaseFirestore.instance
          .collection(
            FirebaseCollectionName.users,
          )
          .doc(userId)
          .set(payload);

      await FirebaseFirestore.instance
          // .collection(
          //   FirebaseCollectionName.users
          // )
          // .doc(userId)
          .collection(FirebaseCollectionName.wallets)
          .doc(walletId)
          .set(walletPayload);

      // TODO: Add default category to firebase
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUserInfo({
    required UserId userId,
    required String displayName,
    required String? email,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(
            FirebaseCollectionName.users,
          )
          .doc(userId)
          .update({
        FirebaseFieldName.displayName: displayName,
        FirebaseFieldName.email: email ?? '',
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String uid) async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    final userDoc = await usersRef.doc(uid).get();
    return userDoc;
  }

// Usage:
// final userDoc = await getUser('userUid');
// final email = userDoc.data()!['email'];
// final displayName = userDoc.data()!['display_name'];
}
