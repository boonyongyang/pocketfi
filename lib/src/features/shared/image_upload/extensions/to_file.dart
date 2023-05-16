import 'dart:io';

import 'package:image_picker/image_picker.dart';

// this is an extension that will be used
// to convert a Future<XFile?> to a Future<File?>
extension ToFile on Future<XFile?> {
  // if the XFile is not null, it will be converted to a File
  Future<File?> toFile() => then((xFile) => xFile?.path)
      // if valid, it will get the path of the XFile and convert it to a File
      // result is a Future<XFile?>, if not null, is an actual XFile
      .then((filePath) => filePath != null ? File(filePath) : null);
}
