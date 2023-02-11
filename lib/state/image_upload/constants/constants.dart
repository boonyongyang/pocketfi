import 'package:flutter/foundation.dart' show immutable;

// default size for photo and videos
@immutable
class Constants {
  // for photo
  static const imageThumbnailWidth = 120;
  static const imageThumbnailHeight = 80;

  // for video
  static const videoThumbnailMaxHeight = 400;
  static const videoThumbnailQuality = 75;

  const Constants._();
}
