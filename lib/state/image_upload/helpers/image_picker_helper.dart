import 'dart:io' show File;

import 'package:flutter/foundation.dart' show immutable;
import 'package:image_picker/image_picker.dart';
import 'package:pocketfi/state/image_upload/extensions/to_file.dart';

// this is a helper class that will be used to pick images and videos from the gallery
@immutable
class ImagePickerHelper {
  // private property that will be used to pick images
  static final ImagePicker _imagePicker = ImagePicker();

  // function that will be used to pick an image from the gallery
  static Future<File?> pickImageFromGallery() =>
      // get source of the image from the gallery and return it as a File
      _imagePicker.pickImage(source: ImageSource.gallery).toFile();

  // function that will be used to pick a video from the gallery
  static Future<File?> pickVideoFromGallery() =>
      // get source of the video from the gallery and return it as a File
      _imagePicker.pickVideo(source: ImageSource.gallery).toFile();
}
