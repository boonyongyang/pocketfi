import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';

class DeletePaidDebtNotifier extends StateNotifier<IsLoading> {
  DeletePaidDebtNotifier() : super(false);

  set isLoading(bool isLoading) => state = isLoading;

  Future<bool> deletePaidDebt({
    required String debtId,
    required String walletId,
    required String userId,
    required String debtPaymentId,
  }) async {
    try {
      isLoading = true;

      final query = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(userId)
          .collection(FirebaseCollectionName.wallets)
          .doc(walletId)
          .collection(FirebaseCollectionName.debts)
          .doc(debtId)
          .collection(FirebaseCollectionName.debtPayments)
          .where(FirebaseFieldName.debtPaymentId, isEqualTo: debtPaymentId)
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
