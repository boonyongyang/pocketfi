import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/image_upload/exceptions/could_not_build_thumbnail_exception.dart';
import 'package:pocketfi/state/image_upload/extensions/get_image_aspect_ratio.dart';
import 'package:pocketfi/state/image_upload/models/file_type.dart';
import 'package:pocketfi/state/image_upload/models/image_with_aspect_ratio.dart';
import 'package:pocketfi/state/image_upload/models/thumbnail_request.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

// this is a provider that will be used to build a thumbnail for a video or image
// it takes a thumbnail request and returns an image with aspect ratio
// the thumbnail request contains the file and the file type
final thumbnailProvider =
    FutureProvider.family.autoDispose<ImageWithAspectRatio, ThumbnailRequest>(
  (
    ref,
    ThumbnailRequest request,
  ) async {
    final Image image;

    switch (request.fileType) {

      // if the file type is an image, then just use the image widget
      case FileType.image:
        image = Image.file(
          request.file,
          fit: BoxFit.fitHeight,
        );
        break;

      // if the file type is a video, then use the video thumbnail package
      case FileType.video:
        final thumb = await VideoThumbnail.thumbnailData(
          video: request.file.path,
          imageFormat: ImageFormat.JPEG,
          quality: 75,
        );
        // if the thumbnail is null, then throw an exception
        if (thumb == null) {
          throw const CouldNotBuildThumbnailException();
        }
        // if the thumbnail is not null, then use the image widget
        image = Image.memory(
          thumb,
          fit: BoxFit.fitHeight,
        );
        break;
    }

    // get the aspect ratio of the image
    final aspectRatio = await image.getAspectRatio();
    return ImageWithAspectRatio(
      image: image,
      aspectRatio: aspectRatio,
    );
  },
);
