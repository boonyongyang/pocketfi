import 'package:pocketfi/src/features/timeline/posts/post_settings/post_constants.dart';

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
