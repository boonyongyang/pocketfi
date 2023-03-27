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

// * contains a list of bookmarked transactions
// class BookmarkTransactionListNotifier extends StateNotifier<List<Transaction>> {
//   BookmarkTransactionListNotifier() : super([]);

// void addBookmark(Transaction transaction) {
//   state = [...state, transaction];
// }

// void removeBookmark(Transaction transaction) {
//   state = state
//       .where((element) => element.transactionId != transaction.transactionId)
//       .toList();
// }

// void toggleTransaction(Transaction transaction) {
//   if (state.contains(transaction)) {
//     removeTransaction(transaction);
//   } else {
//     addTransaction(transaction);
//   }
// }

// void clear() {
//   state = [];
// }
// }

// final bookmarkTransactionListProvider =
//     StateNotifierProvider<BookmarkTransactionListNotifier, List<Transaction>>(
//         (ref) => BookmarkTransactionListNotifier());
