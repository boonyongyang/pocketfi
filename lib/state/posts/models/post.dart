import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/state/image_upload/models/file_type.dart';
import 'package:pocketfi/state/post_settings/models/post_setting.dart';
import 'package:pocketfi/state/posts/models/post_key.dart';

@immutable
class Post {
  final String postId;
  final String userId;
  final String message;
  final double amount;
  final DateTime createdAt;
  final String? thumbnailUrl;
  final String? fileUrl;
  final FileType? fileType;
  final String? fileName;
  final double? aspectRatio;
  final String? thumbnailStorageId;
  final String? originalFileStorageId;
  final Map<PostSetting, bool> postSettings;

  Post({
    required this.postId,
    required Map<String, dynamic> json,
  })  : userId = json[PostKey.userId],
        message = json[PostKey.message],
        amount = json[PostKey.amount],
        createdAt = (json[PostKey.createdAt] as Timestamp).toDate(),
        thumbnailUrl = json[PostKey.thumbnailUrl],
        fileUrl = json[PostKey.fileUrl],
        // it takes the first element of the list that satisfies the condition
        fileType = FileType.values.firstWhere(
          // it checks if the name of the file type is equal to the file type in the json
          (fileType) => fileType.name == json[PostKey.fileType],
          // if no element satisfies the condition, it returns the default value
          orElse: () => FileType.image,
        ),
        fileName = json[PostKey.fileName],
        aspectRatio = json[PostKey.aspectRatio],
        thumbnailStorageId = json[PostKey.thumbnailStorageId],
        originalFileStorageId = json[PostKey.originalFileStorageId],
        postSettings = {
          // it iterates through the entries of the post settings in the json
          for (final entry in json[PostKey.postSettings].entries)
            // it checks if the storage key of the post setting is equal to the key of the entry
            PostSetting.values.firstWhere(
              // if it is, it returns the value of the entry
              (element) => element.storageKey == entry.key,
              // if no element satisfies the condition, it returns the default value
            ): entry.value,
        };

  // it returns true if the post settings contains the post setting and its value is true
  bool get allowsLikes => postSettings[PostSetting.allowLikes] ?? false;
  bool get allowsComments => postSettings[PostSetting.allowComments] ?? false;
}
