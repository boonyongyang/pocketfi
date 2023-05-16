import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart'
    show FieldPath, FirebaseFirestore;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/category/data/category_repository.dart';
import 'package:pocketfi/src/features/debts/domain/debt_payments.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';
import 'package:pocketfi/src/utils/document_id_from_current_date.dart';

final userDebtPaymentsProvider =
    StreamProvider.autoDispose<Iterable<DebtPayment>>((ref) {
  final controller = StreamController<Iterable<DebtPayment>>();

  final sub = FirebaseFirestore.instance
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
      transactionId: transactionId,
    ).toJson();

    final wallets = await FirebaseFirestore.instance
        .collection(FirebaseCollectionName.wallets)
        .doc(walletId)
        .get();

    final debt = await FirebaseFirestore.instance
        .collection(FirebaseCollectionName.debts)
        .doc(debtId)
        .get();

    final transactionPayload = Transaction(
      transactionId: transactionId,
      userId: userId,
      walletId: walletId,
      walletName: wallets.data()![FirebaseFieldName.walletName],
      amount: principleAmount + interestAmount,
      categoryName: ExpenseCategory.billsAndFees.name,
      description:
          '${debt.data()![FirebaseFieldName.debtName]} paid for $paidMonth',
      type: TransactionType.expense,
      date: DateTime.now(),
    ).toJson();

    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.debtPayments)
          .doc(debtPaymentId)
          .set(debtPayload);

      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.transactions)
          .doc(transactionId)
          .set(transactionPayload);

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
    required String transactionId,
  }) async {
    try {
      isLoading = true;

      final debtPaymentQuery = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.debtPayments)
          .where(FirebaseFieldName.debtPaymentId, isEqualTo: debtPaymentId)
          .limit(1)
          .get();

      await debtPaymentQuery.then((debtPaymentQuery) {
        for (final doc in debtPaymentQuery.docs) {
          doc.reference.delete();
        }
      });

      final transactionQuery = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.transactions)
          .where(FieldPath.documentId, isEqualTo: transactionId)
          .limit(1)
          .get();

      await transactionQuery.then((transactionQuery) async {
        final doc = transactionQuery.docs.first;
        await doc.reference.delete();
      });

      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
