import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart' show Image;

@immutable
// to know the aspect ratio of the image, for easier rendering
// can be used when dealing with images and videos
class ImageWithAspectRatio {
  final Image image;
  final double aspectRatio;

  const ImageWithAspectRatio({
    required this.image,
    required this.aspectRatio,
  });
}
