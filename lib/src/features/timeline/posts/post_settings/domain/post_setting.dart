import 'package:flutter/foundation.dart' show immutable;

enum PostSetting {
  allowLikes(
    title: PostConstants.allowLikesTitle,
    description: PostConstants.allowLikesDescription,
    storageKey: PostConstants.allowLikesStorageKey,
  ),

  allowComments(
    title: PostConstants.allowCommentsTitle,
    description: PostConstants.allowCommentsDescription,
    storageKey: PostConstants.allowCommentsStorageKey,
  );

  final String title;
  final String description;
  final String storageKey;

  const PostSetting({
    required this.title,
    required this.description,
    required this.storageKey,
  });
}

@immutable
class PostConstants {
  static const allowLikesTitle = 'Allow likes';
  static const allowLikesDescription =
      'By allowing likes, users will be able to press the like button on your post.';
  static const allowLikesStorageKey = 'allow_likes';
  static const allowCommentsTitle = 'Allow comments';
  static const allowCommentsDescription =
      'By allowing comments, users will be able to comment on your post.';
  static const allowCommentsStorageKey = 'allow_comments';
  const PostConstants._();
}
