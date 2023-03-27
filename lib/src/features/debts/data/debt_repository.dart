import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/debts/domain/debt.dart';
import 'package:pocketfi/src/utils/document_id_from_current_date.dart';

final userDebtsProvider = StreamProvider.autoDispose<Iterable<Debt>>((ref) {
  final userId = ref.watch(userIdProvider);
  final controller = StreamController<Iterable<Debt>>();

  final sub = FirebaseFirestore.instance
      // .collection(FirebaseCollectionName.users)
      // .doc(userId)
      // .collection(FirebaseCollectionName.wallets)
      // .doc(walletId)
      .collectionGroup(FirebaseCollectionName.debts)
      .where(FirebaseFieldName.userId, isEqualTo: userId)
      .snapshots()
      .listen((snapshot) {
    final document = snapshot.docs;
    final debts = document
        .where(
          (doc) => !doc.metadata.hasPendingWrites,
        )
        .map(
          (doc) => Debt.fromJson(doc.data()),
        );

    controller.sink.add(debts);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});

class DebtNotifier extends StateNotifier<IsLoading> {
  DebtNotifier() : super(false);

  set isLoading(bool isLoading) => state = isLoading;

  Future<bool> addNewDebt({
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
