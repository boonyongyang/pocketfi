import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/timeline/posts/post_settings/data/post_setting_notifier.dart';
import 'package:pocketfi/src/features/timeline/posts/post_settings/domain/post_setting.dart';

// this is a provider that will be used to store the post settings
final postSettingProvider =
    StateNotifierProvider<PostSettingNotifier, Map<PostSetting, bool>>(
  (ref) => PostSettingNotifier(),
);
