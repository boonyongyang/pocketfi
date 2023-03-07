import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/shared/image_upload/data/image_upload_notifier.dart';

// this is a provider that will be used to upload images
final imageUploadProvider =
    StateNotifierProvider<ImageUploadNotifier, IsLoading>(
  // create a new instance of the notifier
  (ref) => ImageUploadNotifier(),
);
