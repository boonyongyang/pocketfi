import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/tabs/timeline/posts/post_settings/models/post_setting.dart';
import 'package:pocketfi/state/tabs/timeline/posts/post_settings/notifiers/post_setting_notifier.dart';

// this is a provider that will be used to store the post settings
final postSettingProvider =
    StateNotifierProvider<PostSettingNotifier, Map<PostSetting, bool>>(
  (ref) => PostSettingNotifier(),
);
