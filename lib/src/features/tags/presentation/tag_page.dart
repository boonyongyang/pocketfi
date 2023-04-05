import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/tags/application/tag_services.dart';
import 'package:pocketfi/src/features/tags/data/tag_repository.dart';
import 'package:pocketfi/src/features/tags/presentation/add_new_tag.dart';
import 'package:pocketfi/src/features/tags/presentation/edit_tag.dart';

class TagPage extends ConsumerWidget {
  const TagPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(userTagsProvider).value;
    final tagsList = tags?.toList() ?? [];
    debugPrint('tagsList: $tagsList');

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
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.separated(
                  itemCount: tagsList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: ListTile(
                        title: Text(tagsList[index].name),
                        subtitle: const Text('23 transactions in 2 wallets'),
                        trailing: const Icon(Icons.arrow_forward_ios_outlined),
                      ),
                      onTap: () {
                        ref
                            .read(selectedTagProvider.notifier)
                            .setSelectedTag(tagsList[index]);

                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return const EditTag();
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
