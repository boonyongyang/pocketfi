import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/auth/providers/user_id_provider.dart';
import 'package:pocketfi/state/constants/firebase_collection_name.dart';
import 'package:pocketfi/state/constants/firebase_field_name.dart';
import 'package:pocketfi/state/tabs/timeline/posts/models/post.dart';
import 'package:pocketfi/state/tabs/timeline/posts/models/post_key.dart';

// This provider is used to get the posts of the current user.
// autoDispose is used because the posts of the current user
// will be different for each user.
// The posts of the current user will be different for each user.
final userPostsProvider = StreamProvider.autoDispose<Iterable<Post>>(
  (ref) {
    // get the user id.
    final userId = ref.watch(userIdProvider);

    // The StreamController is used to add the posts to the stream.
    // manages the iterable of posts.
    final controller = StreamController<Iterable<Post>>();

    // The onListen callback is called when the stream is listened to.
    controller.onListen = () {
      // add an empty iterable to the stream.
      controller.sink.add([]);
    };

    // subscribe to the posts collection.
    final sub = FirebaseFirestore.instance
        // get the posts collection.
        .collection(
          FirebaseCollectionName.posts,
        )
        // sort the posts by the created at field.
        .orderBy(
          FirebaseFieldName.createdAt,
          descending: true, // descending order.
        )
        // filter the posts by the user id.
        .where(
          PostKey.userId,
          isEqualTo: userId,
        )
        .snapshots()
        // listen for changes.
        .listen(
      (snapshot) {
        final documents = snapshot.docs; // get the documents of the snapshot
        final posts = documents // get the posts from the documents.
            .where(
              // filter the documents that have no pending writes.
              // this is used to avoid displaying the posts that are being created.
              // the posts that are being created will have pending writes.
              (doc) => !doc.metadata.hasPendingWrites,
            )
            .map(
              // map the documents to posts.
              (doc) => Post(
                postId: doc.id,
                json: doc.data(),
              ),
            );
        // add the posts to the stream.
        controller.sink.add(posts);
      },
    );

    // cancel the subscription when the stream is closed.
    ref.onDispose(() {
      // cancel the subscription.
      sub.cancel();
      // close the stream.
      controller.close();
    });

    // return the stream of posts.
    return controller.stream;
  },
);
