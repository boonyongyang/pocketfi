import 'package:flutter/material.dart'
    show Color, Colors, Icon, IconData, Icons;
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';

// list of colors
const List<Color> colorList = [
  Colors.green,
  Colors.blue,
  Colors.red,
  Colors.yellow,
  Colors.purple,
  Colors.orange,
  Colors.pink,
  Colors.teal,
  Colors.cyan,
  Colors.lime,
  Colors.indigo,
  Colors.brown,
  Colors.amber,
  Colors.deepOrange,
  Colors.deepPurple,
  Colors.lightBlue,
  Colors.lightGreen,
  Colors.black,
];

// list of icons
const List<IconData> iconList = [
  Icons.attach_money,
  Icons.account_balance,
  Icons.account_balance_wallet,
  Icons.account_circle,
  Icons.add_shopping_cart,
  Icons.add_to_home_screen,
  Icons.add_to_photos,
  Icons.add_to_queue,
  Icons.airline_seat_flat,
  Icons.kayaking,
  Icons.local_atm,
  Icons.local_bar,
  Icons.local_cafe,
  Icons.local_car_wash,
  Icons.local_convenience_store,
  Icons.safety_check,
  Icons.sanitizer,
  Icons.satellite,
  Icons.qr_code_scanner,
  Icons.offline_bolt
];

List<Category> expenseCategories = [
  for (final category in ExpenseCategory.values)
    Category(
      name: category.name,
      color: category.color,
      icon: category.icons,
    ),
];

List<Category> incomeCategories = [
  for (final category in IncomeCategory.values)
    Category(
      name: category.name,
      color: category.color,
      icon: category.icons,
    ),
];

const transferCategory = Category(
  name: 'Transfer',
  color: Color(AppColors.transferColor),
  icon: Icon(AppIcons.transferIcon),
);

enum ExpenseCategory {
  foodAndDrink(
    name: "Food and Drinks",
    icons: Icon(
      Icons.restaurant,
      color: AppColors.white,
    ),
    color: AppColors.foodAndDrink,
  ),
  shopping(
    name: "Shopping",
    icons: Icon(
      Icons.shopping_bag,
      color: AppColors.white,
    ),
    color: AppColors.shopping,
  ),
  groceries(
    name: "Groceries",
    icons: Icon(
      Icons.local_grocery_store,
      color: AppColors.white,
    ),
    color: AppColors.groceries,
  ),
  beauty(
    name: "Beauty",
    icons: Icon(
      Icons.face,
      color: AppColors.white,
    ),
    color: AppColors.beauty,
  ),
  entertainment(
    name: "Entertainment",
    icons: Icon(
      Icons.movie,
      color: AppColors.white,
    ),
    color: AppColors.entertainment,
  ),
  healthcare(
    name: "Healthcare",
    icons: Icon(
      Icons.medical_services,
      color: AppColors.white,
    ),
    color: AppColors.healthcare,
  ),
  home(
    name: "Home",
    icons: Icon(
      Icons.home,
      color: AppColors.white,
    ),
    color: AppColors.home,
  ),
  billsAndFees(
    name: "Bills and Fees",
    icons: Icon(
      Icons.money,
      color: AppColors.white,
    ),
    color: AppColors.billsAndFees,
  ),
  familyAndPersonal(
    name: "Family and Personal",
    icons: Icon(
      Icons.family_restroom,
      color: AppColors.white,
    ),
    color: AppColors.familyAndPersonal,
  ),
  travel(
    name: "Travel",
    icons: Icon(
      Icons.airplanemode_active,
      color: AppColors.white,
    ),
    color: AppColors.travel,
  ),
  other(
    name: "Other",
    icons: Icon(
      Icons.more_horiz,
      color: AppColors.white,
    ),
    color: AppColors.other,
  ),
  education(
    name: "Education",
    icons: Icon(
      Icons.school,
      color: AppColors.white,
    ),
    color: AppColors.education,
  ),
  car(
    name: "Car",
    icons: Icon(
      Icons.directions_car,
      color: AppColors.white,
    ),
    color: AppColors.car,
  ),
  gift(
    name: "Gift",
    icons: Icon(
      Icons.card_giftcard,
      color: AppColors.white,
    ),
    color: AppColors.gift,
  ),
  transport(
    name: "Transport",
    icons: Icon(
      Icons.directions_bus,
      color: AppColors.white,
    ),
    color: AppColors.transport,
  ),
  work(
    name: "Work",
    icons: Icon(
      Icons.work,
      color: AppColors.white,
    ),
    color: AppColors.work,
  ),
  sportsAndHobbies(
    name: "Pets",
    icons: Icon(
      Icons.sports_baseball,
      color: AppColors.white,
    ),
    color: AppColors.sportsAndHobbies,
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

enum IncomeCategory {
  salary(
    name: "Salary",
    icons: Icon(
      Icons.work,
      color: AppColors.white,
    ),
    color: AppColors.salary,
  ),
  selling(
    name: "Selling",
    icons: Icon(
      Icons.sell_outlined,
      color: AppColors.white,
    ),
    color: AppColors.selling,
  ),
  loan(
    name: "Loan",
    icons: Icon(
      Icons.attach_money,
      color: AppColors.white,
    ),
    color: AppColors.loan,
  ),
  business(
    name: "Business",
    icons: Icon(
      Icons.business,
      color: AppColors.white,
    ),
    color: AppColors.business,
  ),
  gifts(
    name: "Extra Income",
    icons: Icon(
      Icons.card_giftcard_outlined,
      color: AppColors.white,
    ),
    color: AppColors.extraIncome,
  ),
  others(
    name: "Other",
    icons: Icon(
      Icons.more_horiz,
      color: AppColors.white,
    ),
    color: AppColors.other,
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
