import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/category/application/category_components_providers.dart.dart';
import 'package:pocketfi/src/features/category/application/category_providers.dart';
import 'package:pocketfi/src/features/category/presentation/add_new_category_sheet.dart';
import 'package:pocketfi/src/features/category/presentation/edit_category_sheet.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/add_new_transactions/select_transaction_type.dart';

class CategoryPage extends ConsumerWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final categoriesList = showAllCategories(ref);
    // debugPrint('categoriesList: $categoriesList');

    final categoriesList = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            onPressed: () {
              // ref.read(categoriesProvider.notifier).addCategory();
              // ref.read(categoriesProvider.notifier).removeCategory();
              // ref.read(categoriesProvider.notifier).updateCategory();
// * draggable scrollable sheet
              // showDraggableScrollableSheet(
              //   context: context,
              //   builder: (context) {
              //     return const AddNewCategorySheet();
              //   },
              // );
// * show bottom sheet
// reset selectedColor and Icon providers
              resetCategoryComponentsState(ref);
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return const AddNewCategorySheet();
                },
              );
// * full screen dialog
              //   Navigator.of(context).push(
              //     MaterialPageRoute(
              //       builder: (context) {
              //         return const AddNewCategorySheet();
              //       },
              //       fullscreenDialog: true,
              //     ),
              //   );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          // color: Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SelectTransactionType(
                noOfTabs: 2,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                // color: Colors.blueGrey,
                child: ListView.builder(
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
                        // TODO : JUST USE SEELCTEDCATEGORYPROVIDER
                        // ref.read(selectedCategoryProvider.notifier).state =
                        //     categoriesList[index];

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
                    // return Dismissible(
                    //   onDismissed: (direction) {
                    //     // remove category from list
                    //     // ref.read(categoriesProvider.notifier).removeCategory(
                    //     //       categoriesList[index],
                    //     //     );
                    //     // show snackbar
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       SnackBar(
                    //         content: Text(
                    //           'Category "${categoriesList[index].name}" deleted',
                    //         ),
                    //         action: SnackBarAction(
                    //           label: 'Undo',
                    //           onPressed: () {
                    //             // add category back to list

                    //             // ref
                    //             //     .read(categoriesProvider.notifier)
                    //             //     .addCategory(categoriesList[index]);
                    //           },
                    //         ),
                    //       ),
                    //     );
                    //   },
                    //   key: ValueKey('${categoriesList[index]}'),
                    //   child: ListTile(
                    //     title: Text(categoriesList[index].name),
                    //     leading: CircleAvatar(
                    //       backgroundColor: categoriesList[index].color,
                    //       child: categoriesList[index].icon,
                    //     ),
                    //     trailing: const Icon(Icons.menu),
                    //   ),
                    // );
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
