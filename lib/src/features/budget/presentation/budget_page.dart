import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/button_widget.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/budget/presentation/budget_tile.dart';
import 'package:pocketfi/src/features/category/constants.dart';

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
      body: RefreshIndicator(
        onRefresh: () async {
          // return await ref.refresh(userWalletsProvider);
          // return Future.delayed(const Duration(seconds: 1));
        },
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
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
                                color: AppColors.mainColor1,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Spacer(),
                            // Calculation part
                            Text(
                              'RM XX.XX',
                              style: TextStyle(
                                color: AppColors.mainColor1,
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
                                color: AppColors.mainColor2,
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
                    categoryName: ExpenseCategory.foodAndDrink.name,
                    categoryIcon: ExpenseCategory.foodAndDrink.icons,
                    categoryColor: ExpenseCategory.foodAndDrink.color,
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
                ],
              ),
            ),
            Expanded(
              flex: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(80, 55),
                        backgroundColor: AppColors.mainColor1,
                        foregroundColor: AppColors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                      ),
                      onPressed: () =>
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
