import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/authentication/domain/collaborators_info.dart';
import 'package:pocketfi/src/features/wallets/domain/shared_wallet.dart';
import 'package:pocketfi/src/features/wallets/domain/wallet.dart';
import 'package:pocketfi/src/features/wallets/domain/wallet_payload.dart';

class CheckRequestNotifier extends StateNotifier<bool> {
  CheckRequestNotifier() : super(false);

  // Future<bool> checkRequest(String currentUserId) async {
  //   List pendingRequest = [];
  //   bool contain = false;
  //   FirebaseFirestore.instance
  //       .collectionGroup(FirebaseCollectionName.wallets)
  //       .get()
  //       .then(
  //     (value) {
  //       final doc = value.docs;
  //       for (var i = 0; i < doc.length; i++) {
  //         var collaborators =
  //             doc[i].data()[FirebaseFieldName.collaborators] as List;
  //         print('collaborators before: ${collaborators.toString()}');
  //         for (var j = 0; j < collaborators.length; j++) {
  //           if (collaborators[j][FirebaseFieldName.userId] == currentUserId) {
  //             // print(collaborators[j]);
  //             print('contains');
  //             // addPendingRequest(doc[i].data());
  //             pendingRequest.add(doc[i].data());
  //             print('pendingRequest right after: ${pendingRequest.toString()}');

  //             // print(contain);
  //             // contain = true;
  //           } else {
  //             // print(contain);
  //             print('not contains');
  //             // contain = false;
  //           }
  //         }
  //         print('pendingRequest within loop: ${pendingRequest.toString()}');
  //       }
  //     },
  //   );
  //   print('pendingRequest end: ${pendingRequest.toString()}');

  //   // debugPrint('checkRequestStatus: ${checkRequestStatus.toString()}');
  //   return contain;
  // }
  // Future<List> checkRequest(String currentUserId) async {
  //   List pendingRequest = [];
  //   final querySnapshot = await FirebaseFirestore.instance
  //       .collectionGroup(FirebaseCollectionName.wallets)
  //       .get();

  //   final docs = querySnapshot.docs;
  //   for (var i = 0; i < docs.length; i++) {
  //     var collaborators =
  //         docs[i].data()[FirebaseFieldName.collaborators] as List;
  //     print('collaborators before: ${collaborators.toString()}');
  //     for (var j = 0; j < collaborators.length; j++) {
  //       if (collaborators[j][FirebaseFieldName.userId] == currentUserId &&
  //           collaborators[j][FirebaseFieldName.status] == 'pending') {
  //         print('contains');
  //         pendingRequest.add(docs[i].data());
  //         print('pendingRequest right after: ${pendingRequest.toString()}');
  //       } else {
  //         print('not contains');
  //       }
  //     }
  //     print('pendingRequest within loop: ${pendingRequest.toString()}');
  //   }

  //   print('pendingRequest end: ${pendingRequest.toString()}');
  //   // code that depends on pendingRequest can go here
  //   return pendingRequest;
  // }
  // Future<bool> checkRequest(String currentUserId) async {
  //   final querySnapshot = await FirebaseFirestore.instance
  //       .collectionGroup(FirebaseCollectionName.wallets)
  //       .get();

  //   final docs = querySnapshot.docs;
  //   for (var i = 0; i < docs.length; i++) {
  //     var collaborators =
  //         docs[i].data()[FirebaseFieldName.collaborators] as List;
  //     for (var j = 0; j < collaborators.length; j++) {
  //       if (collaborators[j][FirebaseFieldName.userId] == currentUserId &&
  //           collaborators[j][FirebaseFieldName.status] == 'pending') {
  //         return true; // Found a pending request, return true
  //       }
  //     }
  //   }

  //   return false; // No pending requests found, return false
  // }

  // Future<void> updateStatus(
  //   String status,
  //   String currentUserId,
  //   String inviteeId,
  //   String walletId,
  // ) async {
  //   // update the status of the pending request
  //   final querySnapshot = await FirebaseFirestore.instance
  //       .collection(FirebaseCollectionName.users)
  //       .doc(inviteeId)
  //       .collection(FirebaseCollectionName.wallets)
  //       .doc(walletId)
  //       .update({
  //     FirebaseFieldName.collaborators: FieldValue.arrayUnion([
  //       {
  //         // FirebaseFieldName.userId: currentUserId,
  //         FirebaseFieldName.status: status,
  //       }
  //     ])
  //   });
  // }

  // Future<void> updateStatus(
  //   String status,
  //   String currentUserId,
  //   String inviteeId,
  //   String walletId,
  // ) async {
  //   final walletDocRef = FirebaseFirestore.instance
  //       .collection(FirebaseCollectionName.users)
  //       .doc(inviteeId)
  //       .collection(FirebaseCollectionName.wallets)
  //       .doc(walletId);

  //   final walletDocSnapshot = await walletDocRef.get();

  //   if (!walletDocSnapshot.exists) {
  //     // Handle the case where the wallet document doesn't exist
  //     return;
  //   }

  //   var collaborators =
  //       walletDocSnapshot.data()![FirebaseFieldName.collaborators] as List;
  //   for (var i = 0; i < collaborators.length; i++) {
  //     if (collaborators[i][FirebaseFieldName.userId] == currentUserId &&
  //         collaborators[i][FirebaseFieldName.status] == 'pending') {
  //       // Update the status in the collaborators list
  //       collaborators[i][FirebaseFieldName.status] = status;

  //       // Update the Firestore document with the updated collaborators list
  //       await walletDocRef
  //           .update({FirebaseFieldName.collaborators: collaborators});
  //       break; // Exit the loop after updating the collaborator
  //     }
  //   }
  // }

  Future<void> updateStatus(
    String status,
    String currentUserId,
    String inviteeId,
    String walletId,
  ) async {
    final walletDocRef = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.users)
        .doc(inviteeId)
        .collection(FirebaseCollectionName.wallets)
        .doc(walletId);

    final walletDocSnapshot = await walletDocRef.get();

    if (!walletDocSnapshot.exists) {
      // Handle the case where the wallet document doesn't exist
      return;
    }

    var collaborators =
        walletDocSnapshot.data()![FirebaseFieldName.collaborators] as List;
    for (var i = 0; i < collaborators.length; i++) {
      if (collaborators[i][FirebaseFieldName.userId] == currentUserId &&
          collaborators[i][FirebaseFieldName.status] == 'pending') {
        // Update the status in the collaborators list
        collaborators[i][FirebaseFieldName.status] = status;

        // Update the Firestore document with the updated collaborators list
        await walletDocRef
            .update({FirebaseFieldName.collaborators: collaborators});

        // Add the shared wallet to the collaborator if the status is "accepted"
        if (status == CollaborateRequestStatus.accepted.name) {
          await addSharedWalletToCollaborator(
            currentUserId: currentUserId,
            walletId: walletId,
            walletName: walletDocSnapshot.data()![FirebaseFieldName.walletName],
            ownerId: inviteeId,
            ownerName: walletDocSnapshot.data()![FirebaseFieldName.ownerName],
            ownerEmail: walletDocSnapshot.data()![FirebaseFieldName.ownerEmail],
            createdAt:
                walletDocSnapshot.data()![FirebaseFieldName.createdAt].toDate(),
            // collaborators:
            //     collaborators.map((c) => CollaboratorsInfo.fromMap(c)).toList(),
          );
        }
        // need to check if got budget, then need to add here to the other user too

        break; // Exit the loop after updating the collaborator
      }
    }
  }

  Future<bool> addSharedWalletToCollaborator({
    required String currentUserId,
    required String walletId,
    required String walletName,
    required String ownerId,
    required String ownerName,
    required String? ownerEmail,
    required DateTime? createdAt,
    // List<CollaboratorsInfo>? collaborators,
  }) async {
    final payload = SharedWallet(
      walletId: walletId,
      walletName: walletName,
      userId: currentUserId,
      ownerId: ownerId,
      ownerName: ownerName,
      ownerEmail: ownerEmail!,
      createdAt: createdAt,
      // collaborators: collaborators,
    ).toJson();
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(currentUserId)
          .collection(FirebaseCollectionName.wallets)
          .doc(walletId)
          .set(payload);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Future<void> removeCollaborator({
  //   required String currentUserId,
  //   required String inviteeId,
  //   required String walletId,
  // }) async {
  //   final walletDocRef = FirebaseFirestore.instance
  //       .collection(FirebaseCollectionName.users)
  //       .doc(inviteeId)
  //       .collection(FirebaseCollectionName.wallets)
  //       .doc(walletId);

  //   final walletDocSnapshot = await walletDocRef.get();

  //   if (!walletDocSnapshot.exists) {
  //     // Handle the case where the wallet document doesn't exist
  //     return;
  //   }

  //   var collaborators =
  //       walletDocSnapshot.data()![FirebaseFieldName.collaborators] as List;
  //   for (var i = 0; i < collaborators.length; i++) {
  //     if (collaborators[i][FirebaseFieldName.userId] == currentUserId) {
  //       //! error -> remove the wallet instead of the collaborator in the list
  //       await walletDocRef.delete();
  //       removeSharedWalletFromCollaborator(
  //         currentUserId: currentUserId,
  //         walletId: walletId,
  //       );

  //       break; // Exit the loop after updating the collaborator
  //     }
  //   }
  // }

  Future<void> removeCollaborator({
    required String currentUserId,
    required String inviteeId,
    required String walletId,
    required String collaboratorUserId,
    required String collaboratorUserName,
    required String collaboratorUserEmail,
    // required String? status,
  }) async {
    debugPrint('currentUserId: $currentUserId');
    debugPrint('inviteeId: $inviteeId');
    debugPrint('walletId: $walletId');
    debugPrint('currentUserName: $collaboratorUserName');
    debugPrint('currentUserEmail: $collaboratorUserEmail');
    final walletDocRef = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.users)
        .doc(inviteeId)
        .collection(FirebaseCollectionName.wallets)
        .doc(walletId);

    final walletDocSnapshot = await walletDocRef.get();

    // List collaborators = walletDocSnapshot.get(FirebaseFieldName.collaborators);
    debugPrint('test1');

    if (!walletDocSnapshot.exists) {
      // Handle the case where the wallet document doesn't exist
      return;
    }
    debugPrint('test2');

    var collaborators =
        walletDocSnapshot.data()![FirebaseFieldName.collaborators] as List;
    for (var i = 0; i < collaborators.length; i++) {
      debugPrint('test3');
      if (collaborators[i][FirebaseFieldName.userId] == collaboratorUserId) {
        // Remove the collaborator from the list of collaborators
        debugPrint('test4');
        // ! not working
        // for (final c in collaborators) {
        debugPrint("Collaborators before: ${collaborators.toString()}");
        // }
        collaborators.removeAt(i);
        //  print collaborators code
        debugPrint("Collaborators after remove: ${collaborators.toString()}");
        // for (final c in collaborators) {
        //   if (c == null) {
        //     debugPrint('c is null');
        //   } else {
        //     debugPrint("Collaborators after remove: ${c.toString()}");
        //   }
        // }

        debugPrint(
            'date: ${walletDocSnapshot.data()![FirebaseFieldName.createdAt].toDate()}');

        final payload = WalletPayload(
          walletId: walletId,
          walletName: walletDocSnapshot.data()![FirebaseFieldName.walletName],
          userId: currentUserId,
          ownerId: inviteeId,
          ownerEmail: walletDocSnapshot.data()![FirebaseFieldName.ownerEmail],
          ownerName: walletDocSnapshot.data()![FirebaseFieldName.ownerName],
          createdAt:
              walletDocSnapshot.data()![FirebaseFieldName.createdAt].toDate(),
          collaborators:
              collaborators.map((e) => CollaboratorsInfo.fromMap(e)).toList(),
        ); // .toJson();

        debugPrint('test5');
        // Update the Firestore document with the updated collaborators list
        // await walletDocRef.update({
        //   FirebaseFieldName.collaborators: FieldValue.arrayRemove([
        //     collaboratorUserId,
        //     'accepted',
        //     collaboratorUserName,
        //     collaboratorUserEmail,
        //   ])

        walletDocRef.delete();

        await FirebaseFirestore.instance
            .collection(FirebaseCollectionName.users)
            .doc(inviteeId)
            .collection(FirebaseCollectionName.wallets)
            .doc(walletId)
            .set(payload);

        debugPrint('test6');
        // Remove the shared wallet from the collaborator
        removeSharedWalletFromCollaborator(
          collaboratorUserId: collaboratorUserId,
          walletId: walletId,
        );
        debugPrint('test7');

        break; // Exit the loop after removing the collaborator
      }
    }
  }

  // Future<void> removeCollaborator({
  //   required String currentUserId,
  //   required String inviteeId,
  //   required String walletId,
  //   required String collaboratorUserId,
  //   required String collaboratorUserName,
  //   required String collaboratorUserEmail,
  // }) async {
  //   debugPrint('currentUserId: $currentUserId');
  //   debugPrint('inviteeId: $inviteeId');
  //   debugPrint('walletId: $walletId');
  //   debugPrint('currentUserName: $collaboratorUserName');
  //   debugPrint('currentUserEmail: $collaboratorUserEmail');
  //   final walletDocRef = FirebaseFirestore.instance
  //       .collection(FirebaseCollectionName.users)
  //       .doc(inviteeId)
  //       .collection(FirebaseCollectionName.wallets)
  //       .doc(walletId);

  //   final walletDocSnapshot = await walletDocRef.get();

  //   if (!walletDocSnapshot.exists) {
  //     // Handle the case where the wallet document doesn't exist
  //     return;
  //   }

  //   var collaborators = List<Map<String, dynamic>>.from(
  //       walletDocSnapshot.data()![FirebaseCollectionName.collaborators] ?? []);

  //   final collaboratorToRemove = collaborators.singleWhere(
  //     (collaborator) =>
  //         collaborator[FirebaseFieldName.userId] == collaboratorUserId,
  //     orElse: () => {},
  //   );

  //   // if (collaboratorToRemove == null) {
  //   //   // Handle the case where the collaborator is not found
  //   //   return;
  //   // }

  //   collaborators.remove(collaboratorToRemove);

  //   await walletDocRef.update({
  //     FirebaseCollectionName.collaborators: collaborators,
  //   });

  //   // Remove the shared wallet from the collaborator
  //   removeSharedWalletFromCollaborator(
  //     currentUserId: currentUserId,
  //     walletId: walletId,
  //   );
  // }

  Future<bool> removeSharedWalletFromCollaborator({
    required String collaboratorUserId,
    required String walletId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(collaboratorUserId)
          .collection(FirebaseCollectionName.wallets)
          .doc(walletId)
          .delete();

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Future<bool> updateStatus(
  //   String status,
  //   String currentUserId,
  //   String inviteeId,
  //   String walletId,
  // ) async {
  //   final walletDocRef = FirebaseFirestore.instance
  //       .collection(FirebaseCollectionName.users)
  //       .doc(inviteeId)
  //       .collection(FirebaseCollectionName.wallets)
  //       .doc(walletId);

  //   final walletDocSnapshot = await walletDocRef.get();

  //   if (!walletDocSnapshot.exists) {
  //     // Handle the case where the wallet document doesn't exist
  //     return false;
  //   }

  //   var collaborators =
  //       walletDocSnapshot.data()![FirebaseFieldName.collaborators] as List;
  //   for (var i = 0; i < collaborators.length; i++) {
  //     if (collaborators[i][FirebaseFieldName.userId] == currentUserId &&
  //         collaborators[i][FirebaseFieldName.status] == 'pending') {
  //       // Update the status in the collaborators list
  //       collaborators[i][FirebaseFieldName.status] = status;

  //       try {
  //         // Update the Firestore document with the updated collaborators list
  //         await walletDocRef
  //             .update({FirebaseFieldName.collaborators: collaborators});
  //         return true; // Return true if update was successful
  //       } catch (e) {
  //         // Handle any errors that may occur during the Firestore update operation
  //         print('Error updating collaborators list: $e');
  //         return false;
  //       }
  //     }
  //   }

  //   return false; // Return false if the collaborator wasn't found
  // }

  // Future<void> updateStatus(String status, String currentUserId) async {
  //   final querySnapshot = await FirebaseFirestore.instance
  //       .collectionGroup(FirebaseCollectionName.wallets)
  //       .get();

  //   for (var doc in querySnapshot.docs) {
  //     var collaborators = doc.data()[FirebaseFieldName.collaborators] as List;
  //     for (var i = 0; i < collaborators.length; i++) {
  //       if (collaborators[i][FirebaseFieldName.userId] == currentUserId &&
  //           collaborators[i][FirebaseFieldName.status] == 'pending') {
  //         // Update the status in the collaborators list
  //         collaborators[i][FirebaseFieldName.status] = status;

  //         // Update the Firestore document with the updated collaborators list
  //         await doc.reference
  //             .update({FirebaseFieldName.collaborators: collaborators});
  //       }
  //     }
  //   }
  // }
}

final checkRequestProvider =
    StateNotifierProvider.autoDispose<CheckRequestNotifier, bool>(
  (ref) => CheckRequestNotifier(),
);

// final getPendingRequestProvider = StreamProvider.autoDispose<Iterable>((ref) {
//   final controller = StreamController<Iterable>();
//   final currentUserId = ref.watch(userIdProvider);

//   final querySnapshot = FirebaseFirestore.instance
//       .collectionGroup(FirebaseCollectionName.wallets)
//       .snapshots()
//       .listen((snapshot) {
//     final docs = snapshot.docs;
//     for (var i = 0; i < docs.length; i++) {
//       print('docs: ${docs[i].data().toString()}');
//       var collaborators =
//           docs[i].data()[FirebaseFieldName.collaborators] as List;
//       // print('collaborators before: ${collaborators.toString()}');
//       for (var j = 0; j < collaborators.length; j++) {
//         if (collaborators[j][FirebaseFieldName.userId] == currentUserId) {
//           final pendingRequest = docs.map((doc) => Wallet(
//                 doc.data(),
//               ));
//           print('pendingRequest right after: ${pendingRequest.toString()}');
//           controller.add(pendingRequest);
//         }
//       }
//       // print('pendingRequest within loop: ${pendingRequest.toString()}');
//     }
//   });

//   ref.onDispose(() {
//     // querySnapshot.cancel();
//     controller.close();
//   });
//   return controller.stream;
// });

final getPendingRequestProvider = StreamProvider.autoDispose<Iterable>((ref) {
  final controller = StreamController<Iterable>();
  final currentUserId = ref.watch(userIdProvider);

  final querySnapshot = FirebaseFirestore.instance
      .collectionGroup(FirebaseCollectionName.wallets)
      .snapshots()
      .listen((snapshot) {
    final docs = snapshot.docs;
    final pendingRequest = docs.where((doc) {
      final collaborators = doc.data()[FirebaseFieldName.collaborators];
      return collaborators != null &&
          (collaborators as List).any((collaborator) =>
              collaborator[FirebaseFieldName.userId] == currentUserId &&
              collaborator[FirebaseFieldName.status] == 'pending');
    }).map((doc) => Wallet(
          doc.data(),
        ));

    // final pendingRequest = docs
    //     .where((doc) => (doc.data()[FirebaseFieldName.collaborators] as List)
    //         .any((collaborator) =>
    //             collaborator[FirebaseFieldName.userId] == currentUserId &&
    //             collaborator[FirebaseFieldName.status] == 'pending'))
    //     .map((doc) => Wallet(
    //           doc.data(),
    //         ));

    controller.add(pendingRequest);
  });

  ref.onDispose(() {
    querySnapshot.cancel();
    controller.close();
  });
  return controller.stream;
});
