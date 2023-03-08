import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';

class UpdateWalletStateNotifier extends StateNotifier<IsLoading> {
  UpdateWalletStateNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> updateWallet({
    required String walletId,
    required String walletName,
    // required double walletBalance,
  }) async {
    try {
      isLoading = true;

      final query = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(FirebaseCollectionName.wallets)
          .where(FieldPath.documentId, isEqualTo: walletId)
          .limit(1)
          .get();

      // addListener(() {
      await query.then(
        (query) async {
          for (final doc in query.docs) {
            if (walletName != doc[FirebaseFieldName.walletName]
                // || walletBalance != doc[FirebaseFieldName.walletBalance]
                ) {
              await doc.reference.update(
                {
                  FirebaseFieldName.walletName: walletName,
                  // FirebaseFieldName.walletBalance: walletBalance,
                },
              );

              // notifyListeners();
              // delay 1 seconds
              await Future.delayed(const Duration(seconds: 1));
            }
          }
        },
      );
      // });

      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
