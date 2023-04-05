import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/tags/domain/tag.dart';

// * userTagsProvider
final userTagsProvider = StreamProvider<List<Tag>>((ref) {
  final userId = ref.watch(userIdProvider);

  final controller = StreamController<List<Tag>>();
  controller.onListen = () {
    controller.sink.add([]);
  };

  final sub = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('tags')
      // .where('uid', isEqualTo: userId)
      .snapshots()
      .listen((snapshot) {
    final tags = snapshot.docs
        .map((doc) => Tag.fromJson(
              name: doc['name'],
              json: doc.data(),
            ))
        .toList();

    controller.sink.add(tags);
  });
  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
});

// * TagNotifier
class TagNotifier extends StateNotifier<IsLoading> {
  TagNotifier() : super((false));

  set isLoading(bool isLoading) => state = isLoading;

  // * addNewTag
  Future<bool> addNewTag({
    required String name,
    required String userId,
  }) async {
    try {
      isLoading = true;

      final tag = Tag(
        name: name,
        userId: userId,
        // walletId: 'walletId',
        // walletName: 'walletName',
      ).toJson();

      // * add new tag to firebase
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('tags')
          .doc(name)
          .set(tag);

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      isLoading = false;
    }
  }

  // * deleteTag
  Future<bool> deleteTag() async {
    isLoading = true;

    return true;
  }

  // * updateTag
  Future<bool> updateTag({
    required String originalName,
    required String newName,
    required String userId,
  }) async {
    try {
      isLoading = true;
      // get tag from firebase and update it
      final query = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('tags')
          .where('uid', isEqualTo: userId)
          .where('name', isEqualTo: originalName)
          .get();

      if (query.docs.isEmpty) return false;

      // delete tag from firebase
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('tags')
          .doc(originalName)
          .delete();

      final newTag = Tag(
        name: newName,
        userId: userId,
      ).toJson();

      // create new tag with newName
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('tags')
          .doc(newName)
          .set(newTag);

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      isLoading = false;
    }
  }
}
