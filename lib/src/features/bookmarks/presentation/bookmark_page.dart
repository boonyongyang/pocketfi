import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/bookmarks/data/bookmark_repository.dart';
import 'package:pocketfi/src/features/bookmarks/presentation/bookmark_list_view.dart';
import 'package:pocketfi/src/features/transactions/data/transaction_repository.dart';
import 'package:pocketfi/src/features/transactions/domain/tag.dart';

class BookmarkPage extends ConsumerStatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  BookmarkPageState createState() => BookmarkPageState();
}

class BookmarkPageState extends ConsumerState<BookmarkPage> {
  @override
  Widget build(BuildContext context) {
    final bookmarks = ref.watch(bookmarkTransactionsProvider);
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
        child: bookmarks.when(
          data: (trans) {
            if (trans.isEmpty) {
              return const EmptyContentsWithTextAnimationView(
                text: Strings.youHaveNoPosts,
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // const SelectTransactionType(noOfTabs: 2),
                    const SizedBox(height: 10.0),
                    selectTags(),
                    const SizedBox(height: 20.0),
                    Text(
                        'You have ${bookmarks.value?.length ?? 'No'} bookmarks'),
                    const Divider(),
                    Expanded(
                      child: BookmarkListView(
                        bookmarkedTransactions: trans,
                      ),
                    ),
                  ],
                ),
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

  Row selectTags() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 8.0,
              children: [
                for (final tag in tags)
                  FilterChip(
                    showCheckmark: false,
                    selectedColor: AppColors.mainColor2,
                    label: Text(tag.label),
                    selected: selectedTags.contains(tag),
                    onSelected: (selected) {
                      setState(
                        () {
                          if (selected) {
                            selectedTags.add(tag);
                          } else {
                            selectedTags.remove(tag);
                          }
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
