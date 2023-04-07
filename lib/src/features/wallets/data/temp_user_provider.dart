import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/authentication/domain/collaborators_info.dart';
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
    //retrieve the collaborators in the wallet

    for (var user in users) {
      if (user.userId != currentUserId) {
        final collaborators =
            wallets.docs[0].data()[FirebaseFieldName.collaborators] as List;
        for (var collaborator in collaborators) {
          debugPrint('test2');
          // print('collaborator: $collaborator');
          if (collaborator[FirebaseFieldName.userId] == user.userId &&
              collaborator[FirebaseFieldName.isCollaborator] == true) {
            tempUsers.add(TempUsers(
              userId: user.userId,
              displayName: user.displayName,
              email: user.email,
              isChecked: true,
            ));
            // await FirebaseFirestore.instance
            //     .collection('tempData')
            //     .doc(user.userId)
            //     .set({
            //   'userId': user.userId,
            //   'display_name': user.displayName,
            //   'email': user.email,
            //   'isChecked': true,
            // });
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
        // await FirebaseFirestore.instance
        //     // .collection(FirebaseCollectionName.users)
        //     // .doc(currentUserId)
        //     .collection('tempData')
        //     .doc(user.userId)
        //     .set({
        //   'userId': user.userId,
        //   'display_name': user.displayName,
        //   'email': user.email,
        //   'isChecked': false,
        // });
      }
    }
    // add list of tempdata into firebase
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
        // .collection(FirebaseCollectionName.users)
        // .doc(currentUserId)
        .collection('tempData')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }
  // Future<void> deleteTempDataInFirebase(
  //   String currentUserId,
  //   // String? walletId,
  // ) async {
  //   // Get the temp data from the subcollection
  //   final tempDataSnapshot = await FirebaseFirestore.instance
  //       .collection(FirebaseCollectionName.users)
  //       .doc(currentUserId)
  //       .collection('tempData')
  //       .get();

  //   // Add the temp data to the wallet document
  //   final walletDoc = FirebaseFirestore.instance
  //       .collection(FirebaseCollectionName.users)
  //       .doc(currentUserId)
  //       .collection(FirebaseCollectionName.wallets)
  //       .doc()
  //       .collection('tempData');
  //   for (DocumentSnapshot ds in tempDataSnapshot.docs) {
  //     final data = ds.data() as Map<String, dynamic>;
  //     await walletDoc.doc().set(data, SetOptions(merge: true));
  //   }

  //   // Delete the temp data from the subcollection
  //   for (DocumentSnapshot ds in tempDataSnapshot.docs) {
  //     ds.reference.delete();
  //   }
  // }

  Future<void> addTempDataToFirebaseForDetailView(
    // String walletId,
    List<UserInfo>? users,
    String currentUserId,
  ) async {
    //check if the tempUser already exists in the wallet

    final tempDataSnapshot = await FirebaseFirestore.instance
        // .collection(FirebaseCollectionName.users)
        // .doc(currentUserId)
        .collection('tempData')
        .get();
    final walletDoc = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.users)
        .doc(currentUserId)
        .collection('tempData');
    for (DocumentSnapshot ds in tempDataSnapshot.docs) {
      final data = ds.data() as Map<String, dynamic>;
      await walletDoc.doc().set(data, SetOptions(merge: true));
    }
    //check the collaborators in the wallet
    // if (users == null) return;
    // final walletDocRef = FirebaseFirestore.instance
    //     .collection(FirebaseCollectionName.users)
    //     .doc(currentUserId)
    //     .collection(FirebaseCollectionName.wallets)
    //     .doc(walletId);

    // final walletDocSnapshot = await walletDocRef.get();

    // if (!walletDocSnapshot.exists) {
    //   // Handle the case where the wallet document doesn't exist
    //   return;
    // }

    // var collaborators =
    //     walletDocSnapshot.data()![FirebaseFieldName.collaborators] as List;
    // for (var i = 0; i < collaborators.length; i++) {
    //   if (collaborators.contains(users[i].userId)) {
    //     if (users[i].userId == currentUserId) {
    //       await FirebaseFirestore.instance
    //           .collection(FirebaseCollectionName.users)
    //           .doc(currentUserId)
    //           .collection(FirebaseCollectionName.wallets)
    //           .doc(walletId)
    //           .collection('tempData')
    //           .doc(users[i].userId)
    //           .set({
    //         'userId': users[i].userId,
    //         'display_name': users[i].displayName,
    //         'email': users[i].email,
    //         'isChecked': true,
    //       });
    //     }
    //   } else {
    //     await FirebaseFirestore.instance
    //         .collection(FirebaseCollectionName.users)
    //         .doc(currentUserId)
    //         .collection(FirebaseCollectionName.wallets)
    //         .doc(walletId)
    //         .collection('tempData')
    //         .doc(users[i].userId)
    //         .set({
    //       'userId': users[i].userId,
    //       'display_name': users[i].displayName,
    //       'email': users[i].email,
    //       'isChecked': false,
    //     });
    //   }
    // }
    // for (var user in users) {
    //   if (user.userId != currentUserId) {
    //     await FirebaseFirestore.instance
    //         .collection(FirebaseCollectionName.users)
    //         .doc(currentUserId)
    //         .collection(FirebaseCollectionName.wallets)
    //         .doc(walletId)
    //         .collection('tempData')
    //         .doc(user.userId)
    //         .set({
    //       'userId': user.userId,
    //       'display_name': user.displayName,
    //       'email': user.email,
    //       'isChecked': false,
    //     });
    //   }
    // }
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
          // .collection(FirebaseCollectionName.users)
          // .doc(currentUserId)
          .collection('tempData')
          .doc(user.userId)
          .update({
        'isChecked': value,
      });
    } else if (value == false) {
      // user.isChecked = value!;
      await FirebaseFirestore.instance
          // .collection(FirebaseCollectionName.users)
          // .doc(currentUserId)
          .collection('tempData')
          .doc(user.userId)
          .update({
        'isChecked': value,
      });
    }
  }

  // Future<void> updateIsCheckedInDetailView(
  //   TempUsers user,
  //   bool? value,
  //   String currentUserId,
  //   String walletId,
  // ) async {
  //   if (value == true) {
  //     // user.isChecked = value!;
  //     await FirebaseFirestore.instance
  //         .collection(FirebaseCollectionName.users)
  //         .doc(currentUserId)
  //         .collection(FirebaseCollectionName.wallets)
  //         .doc(walletId)
  //         .collection('tempData')
  //         .doc(user.userId)
  //         .update({
  //       'isChecked': value,
  //     });
  //   } else if (value == false) {
  //     // user.isChecked = value!;
  //     await FirebaseFirestore.instance
  //         .collection(FirebaseCollectionName.users)
  //         .doc(currentUserId)
  //         .collection(FirebaseCollectionName.wallets)
  //         .doc(walletId)
  //         .collection('tempData')
  //         .doc(user.userId)
  //         .update({
  //       'isChecked': value,
  //     });
  //   }
  // }

// Future<void> remainStatusFromFirebase({
//   required List<TempUsers> user,
//   required String currentUserId,
//   required String walletId,
// }) async {
//   //if the user is in the list of collaboratots, then the status is true when creating the temp data collection
//   final walletDocRef = FirebaseFirestore.instance
//       .collection(FirebaseCollectionName.users)
//       .doc(currentUserId)
//       .collection(FirebaseCollectionName.wallets)
//       .doc(walletId);

//   final walletDocSnapshot = await walletDocRef.get();

//   if (!walletDocSnapshot.exists) {
//     // Handle the case where the wallet document doesn't exist
//     return;
//   }

//   final tempData = FirebaseFirestore.instance
//       .collection(FirebaseCollectionName.users)
//       .doc(currentUserId)
//       // get the users collection
//       .collection('tempData');

//   final tempDataSnapshot = await tempData.get();

//   var collaborators =
//       walletDocSnapshot.data()![FirebaseFieldName.collaborators] as List;

//   List tempDataList = tempDataSnapshot.docs;

//   for (var t in tempDataList) {
//     if (tempDataList.contains(collaborators)) {
//       await FirebaseFirestore.instance
//           .collection(FirebaseCollectionName.users)
//           .doc(currentUserId)
//           .collection('tempData')
//           .doc()
//           .update({
//         'isChecked': true,
//       });
//     }
//   }

// for (var i = 0; i < collaborators.length; i++) {
//   if (collaborators.contains(element))
// }
// }
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
  final sub =
      FirebaseFirestore.instance.collection('tempData').snapshots().listen(
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
