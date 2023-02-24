import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/category/models/category.dart';
import 'package:pocketfi/state/category/providers/category_provider.dart';
import 'package:pocketfi/state/tabs/timeline/transaction/models/transaction_type.dart';
import 'package:pocketfi/state/tabs/timeline/transaction/notifiers/transaction_state_notifier.dart';
import 'package:pocketfi/views/constants/app_colors.dart';

class SelectTransactionType extends ConsumerStatefulWidget {
  const SelectTransactionType({super.key});

  @override
  SelectTransactionTypeState createState() => SelectTransactionTypeState();
}

class SelectTransactionTypeState extends ConsumerState<SelectTransactionType>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final tabIndex = ref.watch(transactionTypeProvider);
    List<Category> categoriesList = [];
    if (tabIndex == 0) {
      categoriesList = ref.watch(expenseCategoriesProvider);
    } else if (tabIndex == 1) {
      categoriesList = ref.watch(incomeCategoriesProvider);
    }
// update the categoryProvider
    Future.delayed(
      Duration.zero,
      () {
        ref
            .read(categoriesProvider.notifier)
            .updateCategoriesList(categoriesList);
      },
    );
    Future.delayed(Duration.zero, () {});
    // ref.read(categoriesProvider.notifier).updateCategoriesList(categoriesList);

    return DefaultTabController(
      length: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 45.0,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Consumer(
                builder: (context, watch, child) {
                  return TabBar(
                    indicator: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      color: AppSwatches.mainColor1,
                    ),
                    labelColor: AppSwatches.white,
                    unselectedLabelColor: AppSwatches.mainColor1,
                    tabs: const [
                      Tab(
                        text: 'Expense',
                      ),
                      Tab(
                        text: 'Income',
                      ),
                      Tab(
                        text: 'Transfer',
                      ),
                    ],
                    onTap: (index) {
                      ref
                          .read(transactionTypeProvider.notifier)
                          .setTransactionType(index);
                    },
                    controller: TabController(
                      length: 3,
                      initialIndex: tabIndex,
                      vsync: this,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
