import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/constants/firebase_collection_name.dart';
import 'package:pocketfi/state/image_upload/typedefs/is_loading.dart';
import 'package:pocketfi/state/tabs/budget/wallet/models/wallet_payload.dart';
import 'package:pocketfi/state/tabs/timeline/posts/typedefs/user_id.dart';

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
      await FirebaseFirestore.instance
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
