import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/timeline/bookmarks/presentation/add_transaction_with_bookmark.dart';
import 'package:pocketfi/src/features/timeline/bookmarks/presentation/bookmark_card.dart';
import 'package:pocketfi/src/features/timeline/transactions/application/transaction_providers.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';

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

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddTransactionWithBookmark(),
              ),
            );
          },
        );

        // * using list tile
        // return Padding(
        //   padding:
        //       const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        //   child: Card(
        //     // border radius
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(20.0),
        //     ),
        //     child: ListTile(
        //       leading: CircleAvatar(
        //         child: Padding(
        //           padding: const EdgeInsets.all(6.0),
        //           child: getCategoryWithCategoryName(transaction.categoryName)
        //               .icon,
        //           // child: FittedBox(
        //           // child: Text('\$${transaction.description}'),
        //           // ),
        //         ),
        //       ),
        //       title: Text(
        //         transaction.categoryName,
        //         style: Theme.of(context).textTheme.titleLarge,
        //       ),
        //       subtitle: Text(
        //         DateFormat.yMMMd().format(transaction.date),
        //       ),
        //       trailing: IconButton(
        //         icon: const Icon(Icons.bookmark),
        //         color: AppColors.mainColor2,
        //         iconSize: 32.0,
        //         onPressed: () {},
        //       ),
        //     ),
        //   ),
        // );
      },
    );
  }
}
