import 'package:flutter/foundation.dart' show immutable;

@immutable
class TransactionKey {
  static const userId = 'uid';
  static const description = 'description';
  static const amount = 'amount';
  static const category = 'category';
  static const type = 'type';
  static const isBookmark = 'is_bookmark';
  static const createdAt = 'created_at';
  static const thumbnailUrl = 'thumbnail_url';
  static const fileUrl = 'file_url';
  static const fileType = 'file_type';
  static const fileName = 'file_name';
  static const aspectRatio = 'aspect_ratio';
  static const thumbnailStorageId = 'thumbnail_storage_id';
  static const originalFileStorageId = 'original_file_storage_id';
  // TODO: add tags
  // static const tags = 'tags';
  static const shared = 'shared';

  const TransactionKey._();
}
