import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/category/application/category_providers.dart';
import 'package:pocketfi/src/features/timeline/transactions/application/transaction_provider.dart';

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
    Future.delayed(
      Duration.zero,
      () {
        ref.read(categoriesProvider.notifier).updateCategoriesList(tabIndex);
      },
    );

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
                      color: AppColors.mainColor1,
                    ),
                    labelColor: AppColors.white,
                    unselectedLabelColor: AppColors.mainColor1,
                    tabs: const [
                      Tab(text: Strings.expense),
                      Tab(text: Strings.income),
                      Tab(text: Strings.transfer),
                    ],
                    onTap: (index) {
                      ref
                          .read(transactionTypeProvider.notifier)
                          .setTransactionType(index);

                      final indexSelected = ref.read(transactionTypeProvider);
                      debugPrint('index selected: $indexSelected');
                    },
                    controller: TabController(
                      length: 3,
                      initialIndex: tabIndex.index,
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
