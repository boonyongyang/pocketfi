import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/image_upload/notifiers/image_upload_notifier.dart';
import 'package:pocketfi/state/image_upload/typedefs/is_loading.dart';

// this is a provider that will be used to upload images
final imageUploadProvider =
    StateNotifierProvider<ImageUploadNotifier, IsLoading>(
  // create a new instance of the notifier
  (ref) => ImageUploadNotifier(),
);
