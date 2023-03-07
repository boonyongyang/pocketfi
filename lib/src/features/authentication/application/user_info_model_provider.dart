import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/authentication/domain/user_info.dart';

// create userInfoModelProvider
// has a parameter of UserId
final userInfoModelProvider =
    StreamProvider.family.autoDispose<UserInfo, UserId>((
  ref,
  UserId userId,
) {
  // create a stream controller
  final controller = StreamController<UserInfo>();

  // create a subscription to the user collection
  final sub = FirebaseFirestore.instance
      // get the users collection
      .collection(FirebaseCollectionName.users)
      .where(
        FirebaseFieldName.userId,
        isEqualTo: userId,
      )
      // get the first document
      .limit(1)
      .snapshots()
      .listen(
    (snapshot) {
      // get the first document
      final doc = snapshot.docs.first;
      // get the json data of the document (Map)
      final json = doc.data();
      // deserialize the json to a UserInfoModel
      final userInfoModel = UserInfo.fromJson(
        json,
        userId: userId,
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
