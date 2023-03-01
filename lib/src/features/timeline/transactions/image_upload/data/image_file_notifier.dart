
import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class ImageFileNotifier extends StateNotifier<File?> {
  ImageFileNotifier() : super(null);

  void setImageFile(File? imageFile) {
    state = imageFile;
  }
}

final imageFileProvider = StateNotifierProvider<ImageFileNotifier, File?>(
    (ref) => ImageFileNotifier());
