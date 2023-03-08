import 'dart:io';

import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/src/features/shared/image_upload/domain/file_type.dart';

@immutable
class ThumbnailRequest {
  final File file;
  final FileType fileType;

  const ThumbnailRequest(
    this.file,
    this.fileType,
  );

// when in build function, and is trying to send a reqeust for watch/listen,
// need to make sure that the objects that are sent to the provider are
// actually equatable and have proper hash code,
// if not, build function gets called and called over a loop

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThumbnailRequest &&
          runtimeType == other.runtimeType &&
          file == other.file &&
          fileType == other.fileType;

  @override
  int get hashCode => Object.hashAll(
        [
          runtimeType,
          file,
          fileType,
        ],
      );
}
