import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_collection_name.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/authentication/domain/collaborators_info.dart';
import 'package:pocketfi/src/features/authentication/domain/temp_users.dart';
import 'package:pocketfi/src/features/authentication/domain/user_info_model.dart';

class TempDataNotifier extends StateNotifier<bool> {
  TempDataNotifier(bool state) : super(false);

  Future<void> addTempDataToFirebase(
    List<UserInfoModel>? users,
    String currentUserId,
  ) async {
    if (users == null) return;
    for (var user in users) {
      if (user.userId != currentUserId) {
        await FirebaseFirestore.instance
            .collection(FirebaseCollectionName.users)
            .doc(currentUserId)
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

  Future<void> deleteTempDataInFirebase(String currentUserId) {
    return FirebaseFirestore.instance
        .collection(FirebaseCollectionName.users)
        .doc(currentUserId)
        .collection('tempData')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  // List<dynamic> changeToList(List<dynamic>? users, String currentUserId) {
  //   List userMap = [];
  //   if (users == null) return [];
  //   // addTempDataToFirebase(users, currentUserId);
  //   for (var user in users) {
  //     userMap.add(user);
  //     debugPrint('add user: $user');
  //     // userMap[element].add('isChecked': false);
  //   }
  //   for (var user in users) {
  //     user['isChecked'] = false;
  //   }
  //   return userMap;
  // }

  Future<void> updateIsChecked(
    TempUsers user,
    bool? value,
    String currentUserId,
  ) async {
    if (value == true) {
      // user.isChecked = value!;
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(currentUserId)
          .collection('tempData')
          .doc(user.userId)
          .update({
        'isChecked': value,
      });
    } else if (value == false) {
      // user.isChecked = value!;
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(currentUserId)
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
  // create a stream controller
  final controller = StreamController<Iterable<TempUsers>>();
  final userId = ref.watch(userIdProvider);

  // create a subscription to the user collection
  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.users)
      .doc(userId)
      // get the users collection
      .collection('tempData')
      .snapshots()
      .listen(
    (snapshot) {
      // get the first document
      final docs = snapshot.docs;
      // get the json data of the document (Map)
      // deserialize the json to a UserInfoModel
      final tempUser = docs.map((doc) => TempUsers.fromJson(
            doc.data(),
            userId: doc.id,
          ));
      controller.add(tempUser);
      // controller.sink.add(userInfoModel); // this works too
    },
  );

  // dispose the subscription when the provider is disposed.
  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
