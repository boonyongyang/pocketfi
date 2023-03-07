//get all users in the users collection
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_collection_name.dart';
import 'package:pocketfi/src/features/authentication/domain/user_info_model.dart';

final usersListProvider =
    StreamProvider.autoDispose<Iterable<UserInfoModel>>((ref) {
  // create a stream controller
  final controller = StreamController<Iterable<UserInfoModel>>();

  // create a subscription to the user collection
  final sub = FirebaseFirestore.instance
      // get the users collection
      .collection(FirebaseCollectionName.users)
      .snapshots()
      .listen(
    (snapshot) {
      // get the first document
      final docs = snapshot.docs;
      // get the json data of the document (Map)
      // deserialize the json to a UserInfoModel
      final userInfoModel = docs.map(
        (doc) => UserInfoModel.fromJson(
          doc.data(),
          userId: doc.id,
        ),
      );
      controller.add(userInfoModel);
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
