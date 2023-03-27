import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/debts/domain/debt.dart';
import 'package:pocketfi/src/features/debts/domain/debt_payments.dart';
import 'package:pocketfi/src/utils/document_id_from_current_date.dart';

final userDebtPaymentsProvider = StreamProvider.autoDispose
    .family<Iterable<DebtPayment>, Debt>((ref, Debt debt) {
  final userId = ref.watch(userIdProvider);
  final controller = StreamController<Iterable<DebtPayment>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.debts)
      .doc(debt.debtId)
      .collection(FirebaseCollectionName.debtPayments)
      .snapshots()
      .listen((snapshot) {
    final document = snapshot.docs;
    final debts = document
        .where(
          (doc) => !doc.metadata.hasPendingWrites,
        )
        .map(
          (doc) => DebtPayment.fromJson(doc.data()),
        );

    controller.sink.add(debts);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});

class DebtPaymentNotifier extends StateNotifier<IsLoading> {
  DebtPaymentNotifier() : super(false);

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

  Future<bool> deletePaidDebt({
    required String debtId,
    required String walletId,
    required String userId,
    required String debtPaymentId,
  }) async {
    try {
      isLoading = true;

      final query = FirebaseFirestore.instance
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
