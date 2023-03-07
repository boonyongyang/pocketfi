import 'dart:async' show Completer;

import 'package:flutter/material.dart' as material
    show Image, ImageConfiguration, ImageStreamListener;

// to get the aspect ratio of the image
extension GetImageAspectRatio on material.Image {
  Future<double> getAspectRatio() async {
    // create a completer to return the aspect ratio
    final completer = Completer<double>();
    // add a listener to the image stream
    image.resolve(const material.ImageConfiguration()).addListener(
      material.ImageStreamListener(
        // when the image is loaded, get the aspect ratio
        (imageInfo, synchonousCall) {
          // calculate the aspect ratio
          final aspectRatio = imageInfo.image.width / imageInfo.image.height;
          // dispose the image
          imageInfo.image.dispose();
          // complete the completer with the aspect ratio
          completer.complete(aspectRatio);
        },
      ),
    );
    return completer.future;
  }
}
