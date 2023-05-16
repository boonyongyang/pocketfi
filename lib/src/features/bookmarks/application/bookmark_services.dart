import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/typedefs.dart';

// * used to toggle the state of the bookmark button
class BookmarkNotifier extends StateNotifier<IsBookmark> {
  BookmarkNotifier() : super(false);

  void toggleBookmark() {
    state = !state;
  }

  void resetBookmarkState() {
    state = false;
  }
}

final isBookmarkProvider = StateNotifierProvider<BookmarkNotifier, IsBookmark>(
    (ref) => BookmarkNotifier());
