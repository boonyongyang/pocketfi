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

// "ToFile" can be used on a Future<XFile?> object. 
// The extension adds a new method called toFile() 
// which when called on a Future<XFile?> object, 
// it will then convert the XFile object to a File object 
// by calling the then() method on the future, 
// which allows you to perform some action when the future completes. 
// Inside the then method, it is checking if the XFile object is not null and 
// if it is not, it is getting the path of the XFile object and 
// converting it to a File object by passing the path to the File constructor. 
// The resulting File object is returned in a new future. 
// The last then method is checking if filePath is not null, 
// it will return the file object, otherwise it will return null.