import 'package:flutter/foundation.dart' show immutable;

@immutable
class ImageConstants {
  // for photo
  static const imageThumbnailWidth = 120;
  static const imageThumbnailHeight = 80;

  // for video
  static const videoThumbnailMaxHeight = 400;
  static const videoThumbnailQuality = 75;

  const ImageConstants._();
}
