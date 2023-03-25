import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';

class UpdateDebtNotifier extends StateNotifier<IsLoading> {
  UpdateDebtNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> updateDebt({
    required String debtId,
    required String userId,
    required String walletId,
    required String debtName,
    required double debtAmount,
    required double minimumPayment,
    required double annualInterestRate,
    required int totalNumberOfMonthsToPay,
  }) async {
    try {
      isLoading = true;
      // change the debt name and the debt amount
      final query = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(userId)
          .collection(FirebaseCollectionName.wallets)
          .doc(walletId)
          .collection(FirebaseCollectionName.debts)
          .where(FirebaseFieldName.debtId, isEqualTo: debtId)
          .get();
      await query.then((query) async {
        for (final doc in query.docs) {
          if (debtName != doc[FirebaseFieldName.debtName] ||
              debtAmount != doc[FirebaseFieldName.debtAmount] ||
              minimumPayment != doc[FirebaseFieldName.minimumPayment] ||
              annualInterestRate != doc[FirebaseFieldName.annualInterestRate] ||
              totalNumberOfMonthsToPay !=
                  doc[FirebaseFieldName.totalNumberOfMonthsToPay]) {
            await doc.reference.update({
              FirebaseFieldName.debtName: debtName,
              FirebaseFieldName.debtAmount: debtAmount,
              FirebaseFieldName.minimumPayment: minimumPayment,
              FirebaseFieldName.annualInterestRate: annualInterestRate,
              FirebaseFieldName.totalNumberOfMonthsToPay:
                  totalNumberOfMonthsToPay,
              // FirebaseFieldName.userId: userId,
              // FirebaseFieldName.walletId: walletId,
            });
          }
        }
      });

      // change the wallet?
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
