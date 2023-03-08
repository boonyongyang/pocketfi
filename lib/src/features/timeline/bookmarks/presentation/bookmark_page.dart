import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/timeline/bookmarks/application/bookmark_services.dart';
import 'package:pocketfi/src/features/timeline/bookmarks/presentation/bookmark_list_view.dart';
import 'package:pocketfi/src/features/timeline/transactions/application/transaction_providers.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/add_new_transactions/select_transaction_type.dart';

class BookmarkPage extends ConsumerWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedTransactions = ref.watch(bookmarkTransactionsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          ref.refresh(userTransactionsProvider);
          return Future.delayed(
            const Duration(
              milliseconds: 500,
            ),
          );
        },
        child: bookmarkedTransactions.when(
          data: (trans) {
            if (trans.isEmpty) {
              return const EmptyContentsWithTextAnimationView(
                text: Strings.youHaveNoPosts,
              );
            } else {
              return Column(
                children: [
                  const SelectTransactionType(noOfTabs: 2),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BookmarkListView(
                        bookmarkedTransactions: trans,
                      ),
                    ),
                  ),
                ],
              );
            }
          },
          error: (error, stackTrace) {
            return const ErrorAnimationView();
          },
          loading: () {
            return const LoadingAnimationView();
          },
        ),
      ),
    );
  }
}
