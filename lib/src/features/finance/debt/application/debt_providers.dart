import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/finance/debt/data/add_debt_notifier.dart';
import 'package:pocketfi/src/features/finance/debt/data/add_paid_debt_payment_notifier.dart';
import 'package:pocketfi/src/features/finance/debt/data/delete_debt_notifier.dart';
import 'package:pocketfi/src/features/finance/debt/data/delete_paid_debt_notifier.dart';
import 'package:pocketfi/src/features/finance/debt/data/selected_debt_notifier.dart';
import 'package:pocketfi/src/features/finance/debt/data/update_debt_notifier.dart';
import 'package:pocketfi/src/features/finance/debt/domain/debt.dart';
import 'package:pocketfi/src/features/finance/debt/domain/debt_payments.dart';

import '../../../../constants/firebase_names.dart';

//* Debts
final addDebtProvider = StateNotifierProvider<AddDebtNotifier, IsLoading>(
  (ref) => AddDebtNotifier(),
);
final deleteDebtProvider = StateNotifierProvider<DeleteDebtNotifier, IsLoading>(
  (ref) => DeleteDebtNotifier(),
);
final updateDebtProvider = StateNotifierProvider<UpdateDebtNotifier, IsLoading>(
  (ref) => UpdateDebtNotifier(),
);

//* Paid Debts
final addPaidDebtProvider =
    StateNotifierProvider<AddPaidDebtPaymentNotifier, IsLoading>(
  (ref) => AddPaidDebtPaymentNotifier(),
);
final deletePaidDebtProvider =
    StateNotifierProvider<DeletePaidDebtNotifier, IsLoading>(
  (ref) => DeletePaidDebtNotifier(),
);

//* Selected Debts
final selectedDebtProvider = StateNotifierProvider<SelectedDebtNotifier, Debt?>(
  (_) => SelectedDebtNotifier(null),
);

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
        // .where(
        //   (doc) => !doc.metadata.hasPendingWrites,
        // )
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

final userPaidDebtsProvider = StreamProvider.autoDispose
    .family<Iterable<DebtPayment>, Debt>((ref, Debt debt) {
  final userId = ref.watch(userIdProvider);
  final controller = StreamController<Iterable<DebtPayment>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.users)
      .doc(userId)
      .collection(FirebaseCollectionName.wallets)
      .doc(debt.walletId)
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



// final debtMonthlyAmortization = Provider((ref) => ({
//       required double totalDebtAmount,
//       required double minPaymentPerMonth,
//       required double annualInterestRate,
//       required DateTime createdAt,
//     }) {
//       // Your provider logic here
//       int createdMonth = createdAt.month;

//       double endBalance = totalDebtAmount;
//       double monthlyInterestRate = (annualInterestRate / 100) / 12;
//       double interest = 0;
//       double principle = 0;
//       int months = createdMonth - 1;

//       List<Map<String, dynamic>> tableData = [];

//       while (endBalance > 0 && endBalance > minPaymentPerMonth) {
//         interest = endBalance * monthlyInterestRate;
//         endBalance = endBalance + interest - minPaymentPerMonth;
//         principle = minPaymentPerMonth - interest;
//         months++;

//         // int month = createdMonth + months;
//         // if (month > 12) {
//         //   month -= 12;
//         // }
//         String monthName = DateFormat('MMM yyyy').format(
//           DateTime(createdAt.year, months),
//         );
//         Map<String, dynamic> rowData = {
//           'month': monthName,
//           'interest': interest.toStringAsFixed(2),
//           'principle': principle.toStringAsFixed(2),
//           'endBalance': endBalance.toStringAsFixed(2),
//         };

//         tableData.add(rowData);
//       }

//       interest = endBalance * monthlyInterestRate;
//       principle = endBalance;
//       endBalance = 0.00;
//       months++;

//       String monthName = DateFormat('MMM yyyy').format(
//         DateTime(createdAt.year, months),
//       );

//       Map<String, dynamic> rowData = {
//         'month': monthName,
//         'interest': interest.toStringAsFixed(2),
//         'principle': principle.toStringAsFixed(2),
//         'endBalance': endBalance.toStringAsFixed(2),
//       };

//       tableData.add(rowData);

//       return tableData;
//     });
// // a normal provider of List<Map<String, dynamic>>

