import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart'
    show FieldPath, FirebaseFirestore;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/bills/domain/bill.dart';
import 'package:pocketfi/src/features/wallets/application/wallet_services.dart';
import 'package:pocketfi/src/utils/document_id_from_current_date.dart';

// * get all bills from all wallets
final userBillsProvider = StreamProvider.autoDispose<Iterable<Bill>>(
  (ref) {
    final userId = ref.watch(userIdProvider);
    final walletId = ref.watch(selectedWalletProvider)?.walletId;
    debugPrint('walletId: $walletId');
    final controller = StreamController<Iterable<Bill>>();

    controller.onListen = () {
      controller.sink.add([]);
    };

    final sub = FirebaseFirestore.instance
        // .collection(FirebaseCollectionName.users)
        // .doc(userId)
        // .collection(FirebaseCollectionName.wallets)
        // .doc(walletId)
        // .collection(FirebaseCollectionName.bills)
        // .where(FirebaseFieldName.walletId, isEqualTo: walletId)
        .collectionGroup(FirebaseCollectionName.bills)
        .where(FirebaseFieldName.userId, isEqualTo: userId)
        .orderBy(BillKey.dueDate, descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        final documents = snapshot.docs;
        final bills = documents
            .where(
              (doc) => !doc.metadata.hasPendingWrites,
            )
            .map(
              (doc) => Bill.fromJson(
                billId: doc.id,
                json: doc.data(),
              ),
            );
        controller.sink.add(bills);
      },
    );
    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });
    return controller.stream;
  },
);

// * bill notifier
class BillNotifier extends StateNotifier<IsLoading> {
  BillNotifier() : super(false);

  set isLoading(bool isLoading) => state = isLoading;

  Future<bool> createNewBill({
    required UserId userId,
    required String walletId,
    required String walletName,
    // required String billName,
    required double billAmount,
    required DateTime billDueDate,
    required String categoryName,
    required RecurringPeriod recurringPeriod,
    String? billNote,
  }) async {
    isLoading = true;
    final billId = documentIdFromCurrentDate();
    final Map<String, dynamic> payload;
    try {
      // * perform create new bill
      payload = Bill(
        billId: billId,
        userId: userId,
        walletId: walletId,
        walletName: walletName,
        amount: billAmount,
        dueDate: billDueDate,
        categoryName: categoryName,
        recurringPeriod: recurringPeriod,
        status: BillStatus.unpaid,
        description: billNote ?? '',
      ).toJson();

      debugPrint('uploading new bill..');

      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(userId)
          .collection(FirebaseCollectionName.wallets)
          .doc(walletId)
          .collection(FirebaseCollectionName.bills)
          .doc(billId)
          .set(payload);
      debugPrint('Bill added - $payload');

      return true;
    } catch (e) {
      debugPrint('Error adding bill: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }

  // update bill
  Future<bool> updateBill({
    required String billId,
    required UserId userId,
    required String walletId,
    required String walletName,
    required double billAmount,
    required DateTime billDueDate,
    required String categoryName,
    required RecurringPeriod recurringPeriod,
    String? billNote,
  }) async {
    isLoading = false;

    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(userId)
          .collection(FirebaseCollectionName.wallets)
          .doc(walletId)
          .collection(FirebaseCollectionName.bills)
          .doc(billId)
          .update({
        BillKey.amount: billAmount,
        BillKey.dueDate: billDueDate,
        BillKey.categoryName: categoryName,
        BillKey.recurringPeriod: recurringPeriod.name,
        BillKey.description: billNote ?? '',
      });

      return true;
    } catch (e) {
      debugPrint('Error updating bill: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }

  // delete bill
  Future<bool> deleteBill({
    required String billId,
    required UserId userId,
    required String walletId,
  }) async {
    try {
      isLoading = true;
      final querySnaptshot = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(userId)
          // .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(FirebaseCollectionName.wallets)
          .doc(walletId)
          .collection(FirebaseCollectionName.bills)
          .where(FieldPath.documentId, isEqualTo: billId)
          .limit(1)
          .get();

      await querySnaptshot.then((querySnaptshot) async {
        final doc = querySnaptshot.docs.first;

        await doc.reference.delete();
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      isLoading = false;
    }
  }
}
