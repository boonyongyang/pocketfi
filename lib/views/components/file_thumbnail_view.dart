import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/image_upload/models/thumbnail_request.dart';
import 'package:pocketfi/state/image_upload/providers/thumbnail_provider.dart';
import 'package:pocketfi/views/components/animations/loading_animation_view.dart';
import 'package:pocketfi/views/components/animations/small_error_animation_view.dart';

// used to display a thumbnail for a video or image
class FileThumbnailView extends ConsumerWidget {
  final ThumbnailRequest thumbnailRequest;
  const FileThumbnailView({
    super.key,
    required this.thumbnailRequest,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // get the thumbnail from the provider
    final thumbnail = ref.watch(
      thumbnailProvider(
        thumbnailRequest,
      ),
    );
    // return a different widget depending on the state of the thumbnail
    return thumbnail.when(
      // if the thumbnail is loaded, return the thumbnail
      data: (imageWithAspectRatio) {
        return AspectRatio(
          aspectRatio: imageWithAspectRatio.aspectRatio,
          child: imageWithAspectRatio.image,
        );
      },
      // if the thumbnail is loading, return a loading widget
      loading: () {
        return const LoadingAnimationView();
      },
      // if there is an error, return an error widget
      error: (error, stackTrace) {
        return const SmallErrorAnimationView();
      },
    );
  }
}
