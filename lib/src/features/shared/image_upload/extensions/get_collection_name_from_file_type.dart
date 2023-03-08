import 'package:pocketfi/src/features/shared/image_upload/domain/file_type.dart';

extension CollectionName on FileType {
  String get collectionName {
    switch (this) {
      case FileType.image:
        return 'images';
      case FileType.video:
        return 'videos';
    }
  }
}
