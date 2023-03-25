import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/finance/debt/domain/debt.dart';
import 'package:pocketfi/src/utils/document_id_from_current_date.dart';

class AddDebtNotifier extends StateNotifier<IsLoading> {
  AddDebtNotifier() : super(false);

  set isLoading(bool isLoading) => state = isLoading;

  Future<bool> addDebt({
    required String debtName,
    required double totalDebtAmount,
    required double annualInterestRate,
    required double minimumPayment,
    // required String frequency,
    required String walletId,
    required UserId userId,
    required int totalNumberOfMonthsToPay,
    required double lastMonthInterest,
    required double lastMonthPrinciple,
  }) async {
    isLoading = true;

    final debtId = documentIdFromCurrentDate();

    // final walletDoc = await FirebaseFirestore.instance
    //     .collection(FirebaseCollectionName.users)
    //     .doc(userId)
    //     .collection(FirebaseCollectionName.debts)
    //     .get();

    // Check if the owner ID of the wallet and the user ID are the same
    // final ownerId = walletDoc.docs.first.get(FirebaseFieldName.ownerId);

    final payload = Debt(
      debtId: debtId,
      debtName: debtName,
      debtAmount: totalDebtAmount,
      annualInterestRate: annualInterestRate,
      minimumPayment: minimumPayment,
      // recurringDateToPay: recurrence,
      // frequency: frequency,
      walletId: walletId,
      userId: userId,
      totalNumberOfMonthsToPay: totalNumberOfMonthsToPay,
      lastMonthInterest: lastMonthInterest,
      lastMonthPrinciple: lastMonthPrinciple,
      // ownerId: ownerId != userId ? ownerId : userId,
    ).toJson();

    await FirebaseFirestore.instance
        .collection(FirebaseCollectionName.users)
        .doc(userId)
        .collection(FirebaseCollectionName.wallets)
        .doc(walletId)
        .collection(FirebaseCollectionName.debts)
        .doc(debtId)
        .set(payload);

    isLoading = false;

    return true;
  }
}
