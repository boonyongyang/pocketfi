import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/finance/debt/domain/debt_payments.dart';
import 'package:pocketfi/src/utils/document_id_from_current_date.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';

class AddPaidDebtPaymentNotifier extends StateNotifier<IsLoading> {
  AddPaidDebtPaymentNotifier() : super(false);

  set isLoading(bool isLoading) => state = isLoading;

  Future<bool> addPaidDebt({
    required String debtId,
    required UserId userId,
    required double interestAmount,
    required double principleAmount,
    required double newBalance,
    required double previousBalance,
    required String paidMonth,
    required String walletId,
  }) async {
    isLoading = true;
    final debtPaymentId = documentIdFromCurrentDate();
    final transactionId = documentIdFromCurrentDate();

    final debtPayload = DebtPayment(
      debtPaymentId: debtPaymentId,
      debtId: debtId,
      userId: userId,
      interestAmount: interestAmount,
      principleAmount: principleAmount,
      previousBalance: previousBalance,
      newBalance: newBalance,
      paidMonth: paidMonth,
      isPaid: true,
      walletId: walletId,
    ).toJson();

// add transaction payload
    // final wallets = await FirebaseFirestore.instance
    //     .collection(FirebaseCollectionName.users)
    //     .doc(userId)
    //     .collection(FirebaseCollectionName.wallets)
    //     .doc(walletId)
    //     .get();

    // final Map<String, dynamic> transactionPayload = Transaction(
    //   transactionId: transactionId,
    //   userId: userId,
    //   walletId: walletId,
    //   walletName: wallets.data()![FirebaseFieldName.walletName],
    //   amount: principleAmount + interestAmount,
    //   categoryName: 'debt',
    //   description: null,
    //   type: TransactionType.expense.name,
    //   date: FieldValue.serverTimestamp(),
    // ).toJson();

    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(userId)
          .collection(FirebaseCollectionName.wallets)
          .doc(walletId)
          .collection(FirebaseCollectionName.debts)
          .doc(debtId)
          .collection(FirebaseCollectionName.debtPayments)
          .doc(debtPaymentId)
          .set(debtPayload);

      // at the same time add transaction

      // await FirebaseFirestore.instance
      //     .collection(FirebaseCollectionName.users)
      //     .doc(userId)
      //     .collection(FirebaseCollectionName.wallets)
      //     .doc(walletId)
      //     .collection(FirebaseCollectionName.transactions)
      //     .doc(transactionId)
      //     .set(transactionPayload);

      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
