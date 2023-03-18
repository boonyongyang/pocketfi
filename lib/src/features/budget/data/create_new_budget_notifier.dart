import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/budget/domain/budget.dart';
// import 'package:pocketfi/src/features/budget/domain/budget_payload.dart';
import 'package:pocketfi/src/utils/document_id_from_current_date.dart';

class CreateNewBudgetNotifier extends StateNotifier<IsLoading> {
  CreateNewBudgetNotifier() : super(false);

  set isLoading(bool isLoading) => state = isLoading;

  Future<bool> createNewBudget({
    required String budgetName,
    required double budgetAmount,
    required String walletId,
    required UserId userId,
    required String categoryName,
  }) async {
    isLoading = true;

    final budgetId = documentIdFromCurrentDate();
    //! still need to fix to get the correct walletid
    // final walletId = await FirebaseFirestore.instance
    //     .collection(FirebaseCollectionName.users)
    //     .doc(userId)
    //     .collection(FirebaseCollectionName.wallets)
    //     .limit(1)
    //     .get()
    //     .then((value) => value.docs.first.id);

    // final payload = BudgetPayload(
    //   budgetId: budgetId,
    //   budgetName: budgetName,
    //   budgetAmount: budgetAmount,
    //   usedAmount: 0.00,
    //   walletId: walletId,
    //   userId: userId,
    //   categoryName: categoryName,
    // );

    final walletDoc = await FirebaseFirestore.instance
        .collectionGroup(FirebaseCollectionName.wallets)
        .where(FirebaseFieldName.walletId, isEqualTo: walletId)
        .get();

    // Check if the owner ID of the wallet and the user ID are the same
    final ownerId = walletDoc.docs.first.get(FirebaseFieldName.ownerId);

    final payload = Budget(
      budgetId: budgetId,
      budgetName: budgetName,
      budgetAmount: budgetAmount,
      usedAmount: 0.00,
      walletId: walletId,
      userId: userId,
      categoryName: categoryName,
      ownerId: ownerId != userId ? ownerId : userId,
    ).toJson();

    try {
      final query = FirebaseFirestore.instance
          .collectionGroup(FirebaseCollectionName.wallets)
          .where(FirebaseFieldName.walletId, isEqualTo: walletId)
          .get();

      await query.then(
        (query) async {
          for (final doc in query.docs) {
            await doc.reference
                .collection(FirebaseCollectionName.budgets)
                .doc(budgetId)
                .set(payload);
          }
        },
      );

      // await FirebaseFirestore.instance
      //     .collection(FirebaseCollectionName.users)
      //     .doc(userId)
      //     .collection(FirebaseCollectionName.wallets)
      //     .doc(walletId)
      //     .collection(FirebaseCollectionName.budgets)
      //     .doc(budgetId)
      //     .set(payload);
      // final walletSnapshots = await FirebaseFirestore.instance
      //     .collection(FirebaseCollectionName.users)
      //     .doc(userId)
      //     .collection(FirebaseCollectionName.wallets)
      //     .where(FirebaseFieldName.walletId, isEqualTo: walletId)
      //     .get();
      // for (final walletSnapshot in walletSnapshots.docs) {
      //   await walletSnapshot.reference
      //       .collection(FirebaseCollectionName.budgets)
      //       .doc(budgetId)
      //       .set(payload);
      // }

      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
