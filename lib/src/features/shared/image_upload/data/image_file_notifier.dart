import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart'
    show DefaultCacheManager;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ImageFileNotifier extends StateNotifier<File?> {
  ImageFileNotifier() : super(null);

  void setImageFile(File? imageFile) {
    state = imageFile;
  }

  Future<void> setImageUrl(String url) async {
    final cacheManager = DefaultCacheManager();
    final fileInfo = await cacheManager.getFileFromCache(url);
    if (fileInfo != null && fileInfo.file.existsSync()) {
      state = fileInfo.file;
    } else {
      final file = await cacheManager.getSingleFile(url);
      state = file;
    }
  }

  void clearImageFile() async {
    if (state != null) {
      final cacheManager = DefaultCacheManager();
      await cacheManager.removeFile(state!.path);
      state = null;
    }
  }
}

final imageFileProvider = StateNotifierProvider<ImageFileNotifier, File?>(
    (ref) => ImageFileNotifier());

class ReceiptFileNotifier extends StateNotifier<XFile?> {
  ReceiptFileNotifier() : super(null);

  void setReceiptImageFile(XFile? imageFile) {
    state = imageFile;
  }
}

final receiptFileProvider = StateNotifierProvider<ReceiptFileNotifier, XFile?>(
    (ref) => ReceiptFileNotifier());

class ReceiptStringPathNotifier extends StateNotifier<String?> {
  ReceiptStringPathNotifier() : super(null);

  void setReceiptStringPath(String? imagePath) {
    state = imagePath;
  }

  void clearPath() {
    state = null;
  }
}

final receiptStringPathProvider =
    StateNotifierProvider<ReceiptStringPathNotifier, String?>(
        (ref) => ReceiptStringPathNotifier());
