import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/features/authentication/domain/temp_users.dart';
import 'package:pocketfi/src/features/authentication/domain/user_info.dart';
import 'package:pocketfi/src/features/wallets/domain/wallet.dart';

class TempDataNotifier extends StateNotifier<bool> {
  TempDataNotifier(bool state) : super(false);

  Future<void> addTempDataToFirebase(
    List<UserInfo>? users,
    String currentUserId,
  ) async {
    if (users == null) return;

    for (var user in users) {
      if (user.userId != currentUserId) {
        await FirebaseFirestore.instance
            .collection('tempData')
            .doc(user.userId)
            .set({
          'userId': user.userId,
          'display_name': user.displayName,
          'email': user.email,
          'isChecked': false,
        });
      }
    }
  }

  Future<void> addTempDataDetailToFirebase(
    Wallet wallet,
    List<UserInfo>? users,
    String currentUserId,
  ) async {
    List<TempUsers> tempUsers = [];
    final wallets = await FirebaseFirestore.instance
        .collection(FirebaseCollectionName.wallets)
        .where(FirebaseFieldName.walletId, isEqualTo: wallet.walletId)
        .get();
    if (users == null) return;
    for (var user in users) {
      if (user.userId != currentUserId) {
        final collaborators =
            wallets.docs[0].data()[FirebaseFieldName.collaborators] as List;
        for (var collaborator in collaborators) {
          if (collaborator[FirebaseFieldName.userId] == user.userId &&
              collaborator[FirebaseFieldName.isCollaborator] == true) {
            tempUsers.add(TempUsers(
              userId: user.userId,
              displayName: user.displayName,
              email: user.email,
              isChecked: true,
            ));
          } else {
            await FirebaseFirestore.instance
                .collection('tempData')
                .doc(user.userId)
                .set({
              'userId': user.userId,
              'display_name': user.displayName,
              'email': user.email,
              'isChecked': false,
            });
          }
        }
      }
    }
    for (var tempUser in tempUsers) {
      await FirebaseFirestore.instance
          .collection('tempData')
          .doc(tempUser.userId)
          .set({
        'userId': tempUser.userId,
        'display_name': tempUser.displayName,
        'email': tempUser.email,
        'isChecked': tempUser.isChecked,
      });
    }
  }

  Future<void> deleteTempDataInFirebase(String currentUserId) {
    return FirebaseFirestore.instance
        .collection('tempData')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  Future<void> addTempDataToFirebaseForDetailView(
    List<UserInfo>? users,
    String currentUserId,
  ) async {
    final tempDataSnapshot =
        await FirebaseFirestore.instance.collection('tempData').get();
    final walletDoc = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.users)
        .doc(currentUserId)
        .collection('tempData');
    for (DocumentSnapshot ds in tempDataSnapshot.docs) {
      final data = ds.data() as Map<String, dynamic>;
      await walletDoc.doc().set(data, SetOptions(merge: true));
    }
  }

  Future<void> updateIsChecked(
    TempUsers user,
    bool? value,
    String currentUserId,
  ) async {
    if (value == true) {
      await FirebaseFirestore.instance
          .collection('tempData')
          .doc(user.userId)
          .update({
        'isChecked': value,
      });
    } else if (value == false) {
      await FirebaseFirestore.instance
          .collection('tempData')
          .doc(user.userId)
          .update({
        'isChecked': value,
      });
    }
  }
}

final tempDataProvider =
    StateNotifierProvider.autoDispose<TempDataNotifier, bool>(
  (ref) => TempDataNotifier(false),
);

final getTempDataProvider =
    StreamProvider.autoDispose<Iterable<TempUsers>>((ref) {
  final controller = StreamController<Iterable<TempUsers>>();
  final sub =
      FirebaseFirestore.instance.collection('tempData').snapshots().listen(
    (snapshot) {
      final docs = snapshot.docs;
      final tempUser = docs.map((doc) => TempUsers.fromJson(
            doc.data(),
            userId: doc.id,
          ));
      controller.add(tempUser);
    },
  );
  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
