import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/bookmarks/presentation/add_transaction_with_bookmark.dart';
import 'package:pocketfi/src/features/bookmarks/presentation/bookmark_card.dart';
import 'package:pocketfi/src/features/tags/application/tag_services.dart';
import 'package:pocketfi/src/features/tags/data/tag_repository.dart';
import 'package:pocketfi/src/features/transactions/application/transaction_services.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';

class BookmarkListView extends ConsumerWidget {
  const BookmarkListView({
    super.key,
    required this.bookmarkedTransactions,
  });

  final Iterable<Transaction> bookmarkedTransactions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: bookmarkedTransactions.length,
      itemBuilder: (context, index) {
        final transaction = bookmarkedTransactions.elementAt(index);

        return BookmarkCard(
          transaction: transaction,
          onTapped: () {
            ref
                .read(selectedTransactionProvider.notifier)
                .setSelectedTransaction(transaction);

            ref
                .read(selectedTransactionProvider.notifier)
                .updateTransactionDate(DateTime.now(), ref);

            final allTags = ref.watch(userTagsProvider).value?.toList();

            // loop through allTags and set isSelected for each tag that is in the transaction
            if (allTags != null && allTags.isNotEmpty) {
              ref.read(userTagsNotifier.notifier).resetTagsState(ref);
              for (final tag in allTags) {
                if (transaction.tags.contains(tag.name)) {
                  ref.read(userTagsNotifier.notifier).setTagToSelected(
                        getTagWithName(tag.name, allTags)!,
                      );
                }
              }
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddTransactionWithBookmark(),
              ),
            );
          },
        );
      },
    );
  }
}
