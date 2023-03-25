import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';

class DeleteDebtNotifier extends StateNotifier<IsLoading> {
  DeleteDebtNotifier() : super(false);

  set isLoading(bool isLoading) => state = isLoading;

  Future<bool> deleteDebt({
    required String debtId,
    required String walletId,
    required String userId,
  }) async {
    try {
      isLoading = true;

      final query = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(userId)
          .collection(FirebaseCollectionName.wallets)
          .doc(walletId)
          .collection(FirebaseCollectionName.debts)
          .where(FirebaseFieldName.debtId, isEqualTo: debtId)
          .limit(1)
          .get();

      await query.then((query) {
        for (final doc in query.docs) {
          doc.reference.delete();
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
