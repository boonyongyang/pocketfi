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

  // // clear image file
  // void clearImageFile() {
  //   state = null;
  // }

  void clearImageFile() async {
    if (state != null) {
      final cacheManager = DefaultCacheManager();
      await cacheManager.removeFile(state!.path);
      state = null;
    }
  }

  // Future<void> setImageFile(File imageFile) async {
  //   if (imageFile == state) {
  //     return;
  //   }
  //   state = null;
  //   final file = await DefaultCacheManager().getSingleFile(imageFile.path);
  //   if (file.existsSync()) {
  //     state = file;
  //   } else {
  //     final downloadUrl =
  //         await FirebaseStorage.instance.ref(imageFile.path).getDownloadURL();
  //     final cacheManager = DefaultCacheManager();
  //     final fileInfo = await cacheManager.downloadFile(downloadUrl);
  //     state = fileInfo.file;
  //   }
  // }
}

final imageFileProvider = StateNotifierProvider<ImageFileNotifier, File?>(
    (ref) => ImageFileNotifier());

class ReceiptFileNotifier extends StateNotifier<XFile?> {
  ReceiptFileNotifier() : super(null);

  void setReceiptImageFile(XFile? imageFile) {
    state = imageFile;
  }

  // void setReceiptImageFile(XFile? imageFile) {
  //   state = File(imageFile!.path);
  // }
}

final receiptFileProvider = StateNotifierProvider<ReceiptFileNotifier, XFile?>(
    (ref) => ReceiptFileNotifier());

class ReceiptStringPathNotifier extends StateNotifier<String?> {
  ReceiptStringPathNotifier() : super(null);

  void setReceiptStringPath(String? imagePath) {
    state = imagePath;
  }

  // void setReceiptImageFile(XFile? imageFile) {
  //   state = File(imageFile!.path);
  // }

  void clearPath() {
    state = null;
  }
}

final receiptStringPathProvider =
    StateNotifierProvider<ReceiptStringPathNotifier, String?>(
        (ref) => ReceiptStringPathNotifier());
