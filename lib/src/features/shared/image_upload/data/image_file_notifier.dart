import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ImageFileNotifier extends StateNotifier<File?> {
  ImageFileNotifier() : super(null);

  void setImageFile(File? imageFile) {
    state = imageFile;
  }

  // void setReceiptImageFile(XFile? imageFile) {
  //   state = File(imageFile!.path);
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
