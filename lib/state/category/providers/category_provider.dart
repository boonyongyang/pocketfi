import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/category/models/category.dart';
import 'package:pocketfi/state/category/notifiers/category_state_notifier.dart';
import 'package:pocketfi/state/tabs/timeline/transaction/models/transaction_type.dart';
import 'package:pocketfi/views/constants/app_colors.dart';

List<Category> getCategories(TransactionType transaction) {
  if (transaction == TransactionType.expense) {
    return expenseCategories;
  } else {
    return incomeCategories;
  }
}

final categoriesProvider =
    StateNotifierProvider<CategoryNotifier, List<Category>>(
  (_) => CategoryNotifier(),
);

final expenseCategories = [
  for (final category in ExpenseCategory.values)
    Category(
      name: category.name,
      color: category.color,
      icon: category.icons,
    ),
];

// final incomeCategoriesProvider = Provider<List<Category>>((ref) {
//   // currently hard code here first, these would be the default categories
//   // TODO: need to allow users to custom their own categories
//   return incomeCategories;
// });

final incomeCategories = [
  for (final category in IncomeCategory.values)
    Category(
      name: category.name,
      color: category.color,
      icon: category.icons,
    ),
];

enum ExpenseCategory {
  foodAndDrink(
    name: "Food and Drinks",
    icons: Icon(
      Icons.restaurant,
      color: AppSwatches.white,
    ),
    color: AppSwatches.foodAndDrink,
  ),
  shopping(
    name: "Shopping",
    icons: Icon(
      Icons.shopping_bag,
      color: AppSwatches.white,
    ),
    color: AppSwatches.shopping,
  ),
  groceries(
    name: "Groceries",
    icons: Icon(
      Icons.local_grocery_store,
      color: AppSwatches.white,
    ),
    color: AppSwatches.groceries,
  ),
  beauty(
    name: "Beauty",
    icons: Icon(
      Icons.face,
      color: AppSwatches.white,
    ),
    color: AppSwatches.beauty,
  ),
  entertainment(
    name: "Entertainment",
    icons: Icon(
      Icons.movie,
      color: AppSwatches.white,
    ),
    color: AppSwatches.entertainment,
  ),
  healthcare(
    name: "Healthcare",
    icons: Icon(
      Icons.medical_services,
      color: AppSwatches.white,
    ),
    color: AppSwatches.healthcare,
  ),
  home(
    name: "Home",
    icons: Icon(
      Icons.home,
      color: AppSwatches.white,
    ),
    color: AppSwatches.home,
  ),
  billsAndFees(
    name: "Bills and Fees",
    icons: Icon(
      Icons.money,
      color: AppSwatches.white,
    ),
    color: AppSwatches.billsAndFees,
  ),
  familyAndPersonal(
    name: "Family and Personal",
    icons: Icon(
      Icons.family_restroom,
      color: AppSwatches.white,
    ),
    color: AppSwatches.familyAndPersonal,
  ),
  travel(
    name: "Travel",
    icons: Icon(
      Icons.airplanemode_active,
      color: AppSwatches.white,
    ),
    color: AppSwatches.travel,
  ),
  other(
    name: "Other",
    icons: Icon(
      Icons.more_horiz,
      color: AppSwatches.white,
    ),
    color: AppSwatches.other,
  ),
  education(
    name: "Education",
    icons: Icon(
      Icons.school,
      color: AppSwatches.white,
    ),
    color: AppSwatches.education,
  ),
  car(
    name: "Car",
    icons: Icon(
      Icons.directions_car,
      color: AppSwatches.white,
    ),
    color: AppSwatches.car,
  ),
  gift(
    name: "Gift",
    icons: Icon(
      Icons.card_giftcard,
      color: AppSwatches.white,
    ),
    color: AppSwatches.gift,
  ),
  transport(
    name: "Transport",
    icons: Icon(
      Icons.directions_bus,
      color: AppSwatches.white,
    ),
    color: AppSwatches.transport,
  ),
  work(
    name: "Work",
    icons: Icon(
      Icons.work,
      color: AppSwatches.white,
    ),
    color: AppSwatches.work,
  ),
  sportsAndHobbies(
    name: "Pets",
    icons: Icon(
      Icons.sports_baseball,
      color: AppSwatches.white,
    ),
    color: AppSwatches.sportsAndHobbies,
  );

  final String name;
  final Icon icons;
  final Color color;

  const ExpenseCategory({
    required this.name,
    required this.icons,
    required this.color,
  });
}

// create enums for incomeCategories with name, icon and color
enum IncomeCategory {
  salary(
    name: "Salary",
    icons: Icon(
      Icons.work,
      color: AppSwatches.white,
    ),
    color: AppSwatches.salary,
  ),
  selling(
    name: "Selling",
    icons: Icon(
      Icons.sell_outlined,
      color: AppSwatches.white,
    ),
    color: AppSwatches.selling,
  ),
  loan(
    name: "Loan",
    icons: Icon(
      Icons.attach_money,
      color: AppSwatches.white,
    ),
    color: AppSwatches.loan,
  ),
  business(
    name: "Business",
    icons: Icon(
      Icons.attach_money,
      color: AppSwatches.white,
    ),
    color: AppSwatches.business,
  ),
  gifts(
    name: "Extra Income",
    icons: Icon(
      Icons.card_giftcard_outlined,
      color: AppSwatches.white,
    ),
    color: AppSwatches.extraIncome,
  ),
  others(
    name: "Other",
    icons: Icon(
      Icons.more_horiz,
      color: AppSwatches.white,
    ),
    color: AppSwatches.other,
  );

  final String name;
  final Icon icons;
  final Color color;

  const IncomeCategory({
    required this.name,
    required this.icons,
    required this.color,
  });
}
