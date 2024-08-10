import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/budgets/application/budget_services.dart';
import 'package:pocketfi/src/features/wallets/application/wallet_services.dart';
import 'package:pocketfi/src/features/wallets/domain/wallet.dart';
import 'package:pocketfi/src/features/wallets/presentation/select_wallet_dropdownlist.dart';
import 'package:pocketfi/src/features/category/application/category_services.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/category/presentation/category_page.dart';
import 'package:pocketfi/src/features/transactions/presentation/add_new_transactions/category_selector_view.dart';

class AddNewBudget extends StatefulHookConsumerWidget {
  const AddNewBudget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddNewBudgetState();
}

class _AddNewBudgetState extends ConsumerState<AddNewBudget> {
  @override
  Widget build(BuildContext context) {
    final budgetNameController = useTextEditingController();
    final amountController = useTextEditingController();
    // final selectedWallet = ref.watch(selectedWalletForBudgetProvider);
    final selectedWallet = ref.watch(selectedWalletProvider);

    final expenseCategories = ref.watch(expenseCategoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    final isCreateButtonEnabled = useState(false);

    useEffect(
      () {
        void listener() {
          isCreateButtonEnabled.value = budgetNameController.text.isNotEmpty &&
              amountController.text.isNotEmpty;
        }

        budgetNameController.addListener(listener);
        amountController.addListener(listener);

        return () {
          budgetNameController.removeListener(listener);
          amountController.removeListener(listener);
        };
      },
      [
        budgetNameController,
        amountController,
      ],
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(Strings.createNewBudget),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: AppColors.white,
          ),
          onPressed: () {
            // ref.read(selectedCategoryProvider.notifier).state = null;

            Navigator.of(context).pop();
            resetCategoryState(ref);
            // ref.read(transactionTypeProvider.notifier).setTransactionType(0);
            // ref
            //     .read(transactionTypeProvider.notifier)
            //     .resetTransactionTypeState();

            // ref.read(transactionDateProvider.notifier).setDate(DateTime.now());
          },
        ),
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 32.0),
                      child: SizedBox(
                        width: 5,
                        child: Icon(
                          AppIcons.wallet,
                          color: AppColors.mainColor1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: budgetNameController,
                          decoration: const InputDecoration(
                            labelText: Strings.budgetName,
                          ),
                          autofocus: true,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 32.0),
                      child: SizedBox(
                        width: 5,
                        child: Icon(
                          Icons.money_rounded,
                          color: AppColors.mainColor1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: Strings.amount,
                            hintText: "0.00",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 16.0,
                        top: 35.0,
                        bottom: 8.0,
                      ),
                      child: DropdownButton<String>(
                        hint: const Text(Strings.currency),
                        value: "MYR",
                        items: <String>[
                          "USD",
                          "EUR",
                          "GBP",
                          "CAD",
                          "AUD",
                          "MYR",
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (_) {},
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 16.0,
                        right: 32.0,
                      ),
                      child: SizedBox(
                        width: 5,
                        child: Icon(
                          Icons.category_rounded,
                          color: AppColors.mainColor1,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Categories',
                          style: TextStyle(
                            // color: AppSwatches.mainColor2,
                            // fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 20.0,
                      ),
                      child: SelectCategory(
                          categories: expenseCategories,
                          selectedCategory: selectedCategory),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //     left: 8.0,
                    //     right: 16.0,
                    //     // top: 16.0,
                    //     bottom: 8.0,
                    //   ),
                    //   child: DropdownButton<String>(
                    //     // hint: const Text(Strings.budgetType),
                    //     value: "Expense",
                    //     items: <String>[
                    //       "Expense",
                    //       "Income",
                    //     ].map<DropdownMenuItem<String>>((String value) {
                    //       return DropdownMenuItem<String>(
                    //         value: value,
                    //         child: Text(value),
                    //       );
                    //     }).toList(),
                    //     onChanged: (_) {},
                    //   ),
                    // ),
                  ],
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 32.0),
                      child: SizedBox(
                        width: 5,
                        child: Icon(
                          AppIcons.wallet,
                          color: AppColors.mainColor1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Wallets',
                          style: TextStyle(
                            // color: AppSwatches.mainColor2,
                            // fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                          left: 8.0,
                          right: 16.0,
                          // top: 16.0,
                          bottom: 8.0,
                        ),
                        // child: SelectWalletForBudgetDropdownList()),
                        child: SelectWalletDropdownList()),
                  ],
                ),
              ],
            ),
          ),
          FullWidthButtonWithText(
              text: Strings.createNewBudget,
              onPressed: isCreateButtonEnabled.value
                  ? () async {
                      _createNewBudgetController(
                        budgetNameController,
                        amountController,
                        selectedWallet!,
                        selectedCategory,
                        ref,
                      );
                    }
                  : null),
        ],
      ),
    );
  }

  Future<void> _createNewBudgetController(
    TextEditingController nameController,
    TextEditingController balanceController,
    Wallet selectedWallet,
    Category selectedCategory,
    WidgetRef ref,
  ) async {
    // final selectedCategory = ref.watch(selectedCategoryProvider);

    final userId = ref.read(userIdProvider);
    if (userId == null) {
      return;
    }
    if (balanceController.text.isEmpty) {
      balanceController.text = '0.00';
    }
    final isCreated = await ref.read(budgetProvider.notifier).addNewBudget(
          userId: userId,
          budgetName: nameController.text,
          budgetAmount: double.parse(balanceController.text),
          walletId: selectedWallet.walletId,
          categoryName: selectedCategory.name,
        );
    if (isCreated && mounted) {
      nameController.clear();
      balanceController.clear();
      // Navigator.of(context).pop();
      // Beamer.of(context).beamBack();
      Navigator.of(context).maybePop();
    }
  }

  // Iterable<Wallet> _getWallets() {
  //   final wallets = ref.watch(userWalletsProvider);
  //   return wallets.valueOrNull ?? [];
  // }
}

class SelectCategory extends ConsumerWidget {
  const SelectCategory({
    super.key,
    required this.categories,
    required this.selectedCategory,
  });

  final List<Category> categories;
  final Category? selectedCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Builder(
      builder: (context) {
        return Center(
          child: GestureDetector(
            child: CategorySelectorView(selectedCategory: selectedCategory),
            onTap: () {
              showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.0),
                  ),
                ),
                barrierColor: Colors.black.withOpacity(0.5),
                context: context,
                builder: (context) {
                  return SizedBox(
                    height: 400,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(Strings.selectCategory,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                              IconButton(
                                // icon: const Icon(Icons.add_outlined),
                                icon: const Icon(Icons.settings),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CategoryPage(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 8.0,
                              // mainAxisSpacing: 8.0,
                            ),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(selectedCategoryProvider.notifier)
                                        .state = categories[index];

                                    debugPrint(
                                        'selected category: ${categories[index].name}');
                                    Navigator.of(context).pop();
                                  },
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor:
                                            categories[index].color,
                                        child: categories[index].icon,
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        categories[index].name,
                                        style: const TextStyle(fontSize: 12.0),
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
