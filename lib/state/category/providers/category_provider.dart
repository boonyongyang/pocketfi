import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/category/models/category.dart';
import 'package:pocketfi/state/category/notifiers/category_state_notifier.dart';
import 'package:pocketfi/views/constants/app_colors.dart';

final expenseCategoriesProvider =
    StateNotifierProvider<CategoryNotifier, List<Category>>(
  (_) => CategoryNotifier(),
);

const expenseCategories = [
  Category(
    name: 'Food',
    color: AppSwatches.white,
    icon: Icon(
      Icons.restaurant,
      color: AppSwatches.foodAndDrink,
    ),
  ),
  Category(
    name: 'Transportation',
    color: AppSwatches.white,
    icon: Icon(
      Icons.directions_bus,
      color: AppSwatches.transport,
    ),
  ),
  Category(
    name: 'Shopping',
    color: AppSwatches.white,
    icon: Icon(
      Icons.shopping_cart,
      color: AppSwatches.shopping,
    ),
  ),
  Category(
    name: 'Entertainment',
    color: AppSwatches.white,
    icon: Icon(
      Icons.movie,
      color: AppSwatches.entertainment,
    ),
  ),
  Category(
    name: 'Health',
    color: AppSwatches.white,
    icon: Icon(
      Icons.local_hospital,
      color: AppSwatches.healthcare,
    ),
  ),
  Category(
    name: 'Education',
    color: AppSwatches.white,
    icon: Icon(
      Icons.school,
      color: AppSwatches.education,
    ),
  ),
  Category(
    name: 'Others',
    color: AppSwatches.white,
    icon: Icon(
      Icons.more_horiz,
      color: AppSwatches.other,
    ),
  ),
];

enum ExpenseCategory {
  shopping(
    name: "Shopping",
    icons: Icon(
      Icons.shopping_bag,
      color: AppSwatches.white,
    ),
    color: AppSwatches.shopping,
  ),
  foodAndDrink(
    name: "Food and Drinks",
    icons: Icon(
      Icons.restaurant,
      color: AppSwatches.white,
    ),
    color: AppSwatches.foodAndDrink,
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

final incomeCategoriesProvider = Provider<List<Category>>((ref) {
  // currently hard code here first, these would be the default categories
  // TODO: need to allow users to custom their own categories
  return incomeCategories;
});

const incomeCategories = [
  Category(
    name: 'Salary',
    color: Color(0xFFC59B32),
    icon: Icon(Icons.work),
  ),
  Category(
    name: 'Investment',
    color: Color(0xFFC59B32),
    icon: Icon(Icons.attach_money),
  ),
  Category(
    name: 'Selling',
    color: Color(0xFFD58332),
    icon: Icon(Icons.sell_outlined),
  ),
  Category(
    name: 'Gifts',
    color: Color(0xFFC59332),
    icon: Icon(Icons.card_giftcard_outlined),
  ),
  Category(
    name: 'Others',
    color: Color(0xFFC59B32),
    icon: Icon(Icons.more_horiz),
  ),
];
