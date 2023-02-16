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
      color: AppSwatches.beauty,
    ),
  ),
  Category(
    name: 'Transportation',
    color: AppSwatches.white,
    icon: Icon(
      Icons.directions_bus,
      color: AppSwatches.beauty,
    ),
  ),
  Category(
    name: 'Shopping',
    color: AppSwatches.white,
    icon: Icon(
      Icons.shopping_cart,
      color: AppSwatches.beauty,
    ),
  ),
  Category(
    name: 'Entertainment',
    color: AppSwatches.white,
    icon: Icon(
      Icons.movie,
      color: AppSwatches.beauty,
    ),
  ),
  Category(
    name: 'Health',
    color: AppSwatches.white,
    icon: Icon(
      Icons.local_hospital,
      color: AppSwatches.beauty,
    ),
  ),
  Category(
    name: 'Education',
    color: AppSwatches.white,
    icon: Icon(
      Icons.school,
      color: AppSwatches.beauty,
    ),
  ),
  Category(
    name: 'Others',
    color: AppSwatches.white,
    icon: Icon(
      Icons.more_horiz,
      color: AppSwatches.beauty,
    ),
  ),
];

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
