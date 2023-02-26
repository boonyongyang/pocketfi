import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/timeline/posts/post_settings/domain/post_setting.dart';

// this is a notifier that will be used when the post settings changes
// it takes a map of post settings and a boolean
class PostSettingNotifier extends StateNotifier<Map<PostSetting, bool>> {
  // call the super constructor
  PostSettingNotifier()
      : super(
          // create a map of all the post settings and set them to true
          UnmodifiableMapView(
            {
              // for each post setting, set it to true (default)
              for (final setting in PostSetting.values) setting: true,
            },
          ),
        );

  void setSetting(
    PostSetting setting,
    bool value,
  ) {
    final existingValue = state[setting];
    // return if the existing value is null or same as the new value
    if (existingValue == null || existingValue == value) {
      return;
    }
    // set the state to a new map with the new value
    // this will trigger a rebuild
    // this is the same as using the state = Map.from(state)..[setting] = value;
    // but this is more efficient
    // because it will not rebuild if the value is the same and is null
    // this is because the state is immutable
    // and the state is only updated if the value is different and is not null
    state = Map.unmodifiable(
      // update the key on the current map
      // and set it to the new value
      Map.from(state)..[setting] = value,
    );
  }
}
