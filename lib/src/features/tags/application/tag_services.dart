import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/tags/data/tag_repository.dart';
import 'package:pocketfi/src/features/tags/domain/tag.dart';

// * tagProvider
final tagProvider =
    StateNotifierProvider<TagNotifier, IsLoading>((ref) => TagNotifier());

List<Tag> getTagsWithTagNames(List<String> tagNames, List<Tag> allTags) {
  return allTags.where((tag) => tagNames.contains(tag.name)).toList();
}

// get tag with name
Tag? getTagWithName(String tagName, List<Tag> allTags) {
  return allTags.firstWhereOrNull((tag) => tag.name == tagName);
}

// * userTagsNotifier
final userTagsNotifier = StateNotifierProvider<UserTagsNotifier, List<Tag>>(
    (ref) => UserTagsNotifier(ref.watch(userTagsProvider).value ?? []));

// * UserTagsNotifier
class UserTagsNotifier extends StateNotifier<List<Tag>> {
  UserTagsNotifier(List<Tag> tags) : super(tags);

  void setTags(List<Tag> tags) => state = tags;

  void resetTagsState(ref) {
    final List<Tag> tags = ref.watch(userTagsProvider).value ?? [];
    if (tags.isNotEmpty) {
      state = tags.map((existingTag) {
        return existingTag.copyWith(isSelected: false);
      }).toList();
    } else {
      state = [];
    }
  }

  // * set tag to selected
  void setTagToSelected(Tag tag) {
    state = state.map((existingTag) {
      if (existingTag.name == tag.name) {
        return existingTag.copyWith(isSelected: true);
      } else {
        return existingTag;
      }
    }).toList();
  }
}

// * selectedTagProvider
final selectedTagProvider = StateNotifierProvider<SelectedTagNotifier, Tag?>(
    (ref) => SelectedTagNotifier(null));

// * SelectedTagNotifier
class SelectedTagNotifier extends StateNotifier<Tag?> {
  SelectedTagNotifier(Tag? tag) : super(tag);
  void setSelectedTag(Tag tag) => state = tag;
  void resetSelectedTagState() => state = null;
}
