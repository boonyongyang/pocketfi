import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/features/tags/application/tag_services.dart';
import 'package:pocketfi/src/features/tags/data/tag_repository.dart';
import 'package:pocketfi/src/features/tags/domain/tag.dart';
import 'package:pocketfi/src/features/tags/presentation/add_new_tag.dart';
import 'package:pocketfi/src/features/tags/presentation/update_tag.dart';
import 'package:pocketfi/src/features/transactions/data/transaction_repository.dart';

class TagPage extends ConsumerWidget {
  const TagPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(userTagsProvider).value;
    final tagsList = tags?.toList() ?? [];
    debugPrint('tagsList: $tagsList');
    final transactions = ref.watch(userTransactionsProvider).value;

    // Create a map to store the number of times each tag has been used
    final tagUsage = <Tag, int>{};

    // Loop through the transactions and count the number of times each tag has been used
    for (final transaction in transactions!) {
      final tags = getTagsWithTagNames(transaction.tags, tagsList);
      for (final tag in tags) {
        tagUsage[tag] = (tagUsage[tag] ?? 0) + 1;
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Tags'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // reset selectedColor and Icon providers
              // resetCategoryComponentsState(ref);
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return const AddNewTag();
                },
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
          child: tagsList.isEmpty
              ? const Center(
                  child: EmptyContentsWithTextAnimationView(
                      text:
                          'No tags yet. Add a new tag by tapping the + icon above.'),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.separated(
                        itemCount: tagsList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: ListTile(
                              title: Text(tagsList[index].name),
                              subtitle: Text(
                                  '${tagUsage[tagsList[index]] ?? 0} transaction(s)'),
                              //  subtitle: Text(
                              //   '${tagUsage[tagsList[index]]} transaction${tagUsage[tagsList[index]] == 1 ? '' : 's'}',
                              // ),
                              trailing: const Icon(Icons.edit),
                            ),
                            onTap: () {
                              ref
                                  .read(selectedTagProvider.notifier)
                                  .setSelectedTag(tagsList[index]);

                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return const UpdateTag();
                                },
                              );
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
