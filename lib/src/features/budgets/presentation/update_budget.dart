import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/common_widgets/dialogs/alert_dialog_model.dart';
import 'package:pocketfi/src/common_widgets/dialogs/delete_dialog.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/budgets/application/budget_services.dart';
import 'package:pocketfi/src/features/category/application/category_services.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/category/presentation/category_page.dart';
import 'package:pocketfi/src/features/transactions/presentation/add_new_transactions/category_selector_view.dart';
import 'package:pocketfi/src/features/wallets/data/wallet_repository.dart';

class UpdateBudget extends StatefulHookConsumerWidget {
  const UpdateBudget({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdateBudgetState();
}

class _UpdateBudgetState extends ConsumerState<UpdateBudget> {
  @override
  Widget build(BuildContext context) {
    final selectedBudget = ref.watch(selectedBudgetProvider);
    final budgetNameController =
        useTextEditingController(text: selectedBudget?.budgetName);
    final amountController = useTextEditingController(
        text: selectedBudget?.budgetAmount.toStringAsFixed(2));
    final expenseCategories = ref.watch(expenseCategoriesProvider);
    final wallet = ref.watch(
        getWalletFromWalletIdProvider(selectedBudget!.walletId.toString()));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Budget Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_rounded),
            onPressed: () async {
              final deletePost = await const DeleteDialog(
                titleOfObjectToDelete: 'Budget',
              ).present(context);
              if (deletePost == null) return;
              if (deletePost) {
                await ref
                    .read(budgetProvider.notifier)
                    .deleteBudget(budgetId: selectedBudget.budgetId);
                if (mounted) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              }
            },
          ),
        ],
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
                          selectedCategory: getCategoryWithCategoryName(
                              ref.watch(selectedBudgetProvider)?.categoryName)),
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
                          AppIcons.wallet,
                          color: AppColors.mainColor1,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Wallet selected',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 32.0,
                      ),
                      child: Text(
                        wallet.when(
                          data: (wallet) {
                            return wallet.walletName;
                          },
                          error: (error, stack) {
                            return error.toString();
                          },
                          loading: () => 'Loading...',
                        ),
                        style: const TextStyle(
                          color: AppColors.mainColor1,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          FullWidthButtonWithText(
            text: 'Save Changes',
            onPressed: () {
              _updateBudgetController(
                budgetNameController,
                amountController,
                ref,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _updateBudgetController(
    TextEditingController nameController,
    TextEditingController amountController,
    WidgetRef ref,
  ) async {
    final userId = ref.read(userIdProvider);
    if (userId == null) {
      return;
    }
    final selectedBudget = ref.watch(selectedBudgetProvider);
    final isUpdated = await ref.read(budgetProvider.notifier).updateBudget(
          walletId: selectedBudget!.walletId,
          budgetName: nameController.text,
          budgetId: selectedBudget.budgetId,
          budgetAmount: double.parse(amountController.text),
          categoryName: ref.read(selectedBudgetProvider)?.categoryName,
        );
    if (isUpdated && mounted) {
      nameController.clear();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }
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
                            ),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(selectedBudgetProvider.notifier)
                                        .updateCategory(categories[index], ref);
                                    Navigator.of(context).pop();
                                  },
                                  child: Column(
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
