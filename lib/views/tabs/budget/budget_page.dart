import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/category/models/category_setting.dart';
import 'package:pocketfi/views/constants/app_colors.dart';
import 'package:pocketfi/views/constants/button_widget.dart';
import 'package:pocketfi/views/constants/strings.dart';
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
            onPressed: () =>
                // {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     // builder: (_) => const WalletPage(),
                //     builder: (_) => const CreateNewWalletView(),
                //   ),
                // );

                context.beamToNamed("wallet"),
            // },
            // BeamerButton(
            //   beamer: beamer,
            //   uri: '/budget/wallet',
            //   child: const Icon(Icons.wallet),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Text(
                        'Total',
                        style: TextStyle(
                          color: AppSwatches.mainColor1,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Spacer(),
                      // Calculation part
                      Text(
                        'RM XX.XX',
                        style: TextStyle(
                          color: AppSwatches.mainColor1,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      // Calculation part
                      Text(
                        'RM XX.XX left',
                        style: TextStyle(
                          color: AppSwatches.mainColor2,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
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
            // BudgetTile(
            //   budget: 12.00,
            //   categoryName: CategorySetting.groceries.name,
            //   categoryIcon: CategorySetting.groceries.icons,
            //   categoryColor: CategorySetting.groceries.color,
            // ),
            // BudgetTile(
            //   budget: 12.00,
            //   categoryName: CategorySetting.shopping.name,
            //   categoryIcon: CategorySetting.shopping.icons,
            //   categoryColor: CategorySetting.shopping.color,
            // ),
            // BudgetTile(
            //   budget: 12.00,
            //   categoryName: CategorySetting.beauty.name,
            //   categoryIcon: CategorySetting.beauty.icons,
            //   categoryColor: CategorySetting.beauty.color,
            // ),
            // BudgetTile(
            //   budget: 12.00,
            //   categoryName: CategorySetting.billsAndFees.name,
            //   categoryIcon: CategorySetting.billsAndFees.icons,
            //   categoryColor: CategorySetting.billsAndFees.color,
            // ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(80, 55),
                  backgroundColor: AppSwatches.mainColor1,
                  foregroundColor: AppSwatches.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                ),
                onPressed:
                    // ref.read(authStateProvider.notifier).loginWithFacebook,
                    () =>
                        // {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => const CreateNewBudgetView(),
                        //   ),
                        // );
                        context.beamToNamed("createNewBudget"),
                // },
                child: const ButtonWidget(
                  text: Strings.createNewBudget,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
