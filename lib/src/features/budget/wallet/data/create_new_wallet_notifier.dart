import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_collection_name.dart';
import 'package:pocketfi/src/constants/firebase_field_name.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet_payload.dart';
import 'package:pocketfi/src/constants/typedefs.dart';

class CreateNewWalletNotifier extends StateNotifier<IsLoading> {
  CreateNewWalletNotifier() : super(false);

  set isLoading(bool isLoading) => state = isLoading;

  Future<bool> createNewWallet({
    required String walletName,
    double? walletBalance = 0.00,
    required UserId userId,
  }) async {
    isLoading = true;

    final payload = WalletPayload(
      walletName: walletName,
      walletBalance: walletBalance,
      userId: userId,
    );
    try {
      // final docId = await FirebaseFirestore.instance
      //     .collection(FirebaseCollectionName.users)
      //     .where(FirebaseFieldName.userId, isEqualTo: userId)
      //     .limit(1)
      //     .get()
      //     .then((value) => value.docs.first.id);
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(userId)
          .collection(FirebaseCollectionName.wallets)
          .add(payload);
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
