import 'package:flutter/material.dart' show Color, Icon, Icons;
import 'package:pocketfi/views/constants/app_colors.dart';

enum CategorySetting {
  shopping(
    name: "Shopping",
    icons: Icon(
      Icons.shopping_bag,
      color: AppSwatches.white,
    ),
    color: AppSwatches.shopping,
    // storageKey: Constants.expenseStorageKey,
  ),
  foodAndDrink(
    name: "Food and Drinks",
    icons: Icon(
      Icons.restaurant,
      color: AppSwatches.white,
    ),
    color: AppSwatches.foodAndDrink,

    // storageKey: Constants.incomeStorageKey,
  ),
  groceries(
    name: "Groceries",
    icons: Icon(
      Icons.local_grocery_store,
      color: AppSwatches.white,
    ),
    color: AppSwatches.groceries,
    // storageKey: Constants.transferStorageKey,
  ),
  beauty(
    name: "Beauty",
    icons: Icon(
      Icons.face,
      color: AppSwatches.white,
    ),
    color: AppSwatches.beauty,
    // storageKey: Constants.transferStorageKey,
  ),
  entertainment(
    name: "Entertainment",
    icons: Icon(
      Icons.movie,
      color: AppSwatches.white,
    ),
    color: AppSwatches.entertainment,
    // storageKey: Constants.transferStorageKey,
  ),
  healthcare(
    name: "Healthcare",
    icons: Icon(
      Icons.medical_services,
      color: AppSwatches.white,
    ),
    color: AppSwatches.healthcare,
    // storageKey: Constants.transferStorageKey,
  ),
  home(
    name: "Home",
    icons: Icon(
      Icons.home,
      color: AppSwatches.white,
    ),
    color: AppSwatches.home,
    // storageKey: Constants.transferStorageKey,
  ),
  billsAndFees(
    name: "Bills and Fees",
    icons: Icon(
      Icons.money,
      color: AppSwatches.white,
    ),
    color: AppSwatches.billsAndFees,
    // storageKey: Constants.transferStorageKey,
  ),
  familyAndPersonal(
    name: "Family and Personal",
    icons: Icon(
      Icons.family_restroom,
      color: AppSwatches.white,
    ),
    color: AppSwatches.familyAndPersonal,
    // storageKey: Constants.transferStorageKey,
  ),
  travel(
    name: "Travel",
    icons: Icon(
      Icons.airplanemode_active,
      color: AppSwatches.white,
    ),
    color: AppSwatches.travel,
    // storageKey: Constants.transferStorageKey,
  ),
  other(
    name: "Other",
    icons: Icon(
      Icons.more_horiz,
      color: AppSwatches.white,
    ),
    color: AppSwatches.other,
    // storageKey: Constants.transferStorageKey,
  ),
  education(
    name: "Education",
    icons: Icon(
      Icons.school,
      color: AppSwatches.white,
    ),
    color: AppSwatches.education,
    // storageKey: Constants.transferStorageKey,
  ),
  car(
    name: "Car",
    icons: Icon(
      Icons.directions_car,
      color: AppSwatches.white,
    ),
    color: AppSwatches.car,
    // storageKey: Constants.transferStorageKey,
  ),
  gift(
    name: "Gift",
    icons: Icon(
      Icons.card_giftcard,
      color: AppSwatches.white,
    ),
    color: AppSwatches.gift,
    // storageKey: Constants.transferStorageKey,
  ),
  transport(
    name: "Transport",
    icons: Icon(
      Icons.directions_bus,
      color: AppSwatches.white,
    ),
    color: AppSwatches.transport,
    // storageKey: Constants.transferStorageKey,
  ),
  work(
    name: "Work",
    icons: Icon(
      Icons.work,
      color: AppSwatches.white,
    ),
    color: AppSwatches.work,
    // storageKey: Constants.transferStorageKey,
  ),
  sportsAndHobbies(
    name: "Pets",
    icons: Icon(
      Icons.sports_baseball,
      color: AppSwatches.white,
    ),
    color: AppSwatches.sportsAndHobbies,
    // storageKey: Constants.transferStorageKey,
  );

  final String name;
  final Icon icons;
  final Color color;
  // final String storageKey;

  const CategorySetting({
    required this.name,
    required this.icons,
    required this.color,
    // required this.storageKey,
  });
}
