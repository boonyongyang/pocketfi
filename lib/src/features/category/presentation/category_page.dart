import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/category/application/category_services.dart';
import 'package:pocketfi/src/features/category/presentation/add_new_category.dart';
import 'package:pocketfi/src/features/category/presentation/edit_category_sheet.dart';
import 'package:pocketfi/src/features/transactions/presentation/add_new_transactions/select_transaction_type.dart';

class CategoryPage extends ConsumerWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesList = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Categories'),
        actions: [
          IconButton(
            onPressed: () {
              resetCategoryComponentsState(ref);
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return const AddNewCategory();
                },
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SelectTransactionType(
                noOfTabs: 2,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.separated(
                  itemCount: categoriesList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: ListTile(
                        title: Text(categoriesList[index].name),
                        leading: CircleAvatar(
                          backgroundColor: categoriesList[index].color,
                          child: categoriesList[index].icon,
                        ),
                        trailing: const Icon(Icons.menu),
                      ),
                      onTap: () {
                        ref.read(selectedCategoryColorProvider.notifier).state =
                            categoriesList[index].color;
                        ref.read(selectedCategoryIconProvider.notifier).state =
                            categoriesList[index].icon.icon;
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return EditCategorySheet(
                                category: categoriesList[index]);
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
