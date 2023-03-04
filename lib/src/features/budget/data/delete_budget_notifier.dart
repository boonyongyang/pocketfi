import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_collection_name.dart';
import 'package:pocketfi/src/constants/typedefs.dart';

class DeleteBudgetStateNotifier extends StateNotifier<IsLoading> {
  DeleteBudgetStateNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> deleteBudget({
    required String budgetId,
  }) async {
    try {
      //!need to check the correct wallet
      final wallets = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(FirebaseCollectionName.wallets)
          .get();
      isLoading = true;

      if (wallets.docs.length == 1) {
        return false;
      }

      final query = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(FirebaseCollectionName.wallets)
          .doc(wallets.docs.first.id)
          .collection(FirebaseCollectionName.budgets)
          .where(FieldPath.documentId, isEqualTo: budgetId)
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
