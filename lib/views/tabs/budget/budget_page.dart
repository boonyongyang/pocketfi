import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/category/models/category_setting.dart';
import 'package:pocketfi/views/tabs/budget/budget_tile.dart';

class BudgetPage extends ConsumerStatefulWidget {
  const BudgetPage({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BudgetPageState();
}

class _BudgetPageState extends ConsumerState<BudgetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget'),
        actions: [
          IconButton(
            icon: const Icon(Icons.wallet),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: const [
                  Text('Budget'),
                  Spacer(),
                  Text('RM 0.00'),
                ],
              ),
            ),
            const Divider(),
            BudgetTile(
              budget: 12.00,
              categoryName: CategorySetting.foodAndDrink.name,
              categoryIcon: CategorySetting.foodAndDrink.icons,
              categoryColor: CategorySetting.foodAndDrink.color,
            ),
            BudgetTile(
              budget: 12.00,
              categoryName: CategorySetting.groceries.name,
              categoryIcon: CategorySetting.groceries.icons,
              categoryColor: CategorySetting.groceries.color,
            ),
            BudgetTile(
              budget: 12.00,
              categoryName: CategorySetting.shopping.name,
              categoryIcon: CategorySetting.shopping.icons,
              categoryColor: CategorySetting.shopping.color,
            ),
            BudgetTile(
              budget: 12.00,
              categoryName: CategorySetting.beauty.name,
              categoryIcon: CategorySetting.beauty.icons,
              categoryColor: CategorySetting.beauty.color,
            ),
            BudgetTile(
              budget: 12.00,
              categoryName: CategorySetting.billsAndFees.name,
              categoryIcon: CategorySetting.billsAndFees.icons,
              categoryColor: CategorySetting.billsAndFees.color,
            ),
          ],
        ),
      ),
    );
  }
}
