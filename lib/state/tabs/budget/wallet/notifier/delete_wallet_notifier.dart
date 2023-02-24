import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/constants/firebase_collection_name.dart';
import 'package:pocketfi/state/image_upload/typedefs/is_loading.dart';

class DeleteWalletStateNotifier extends StateNotifier<IsLoading> {
  DeleteWalletStateNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> deleteWallet({
    required String walletId,
  }) async {
    try {
      isLoading = true;

      final query = FirebaseFirestore.instance
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
