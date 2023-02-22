import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart' show Color, Icon, Icons;
import 'package:pocketfi/state/category/models/category.dart';

@immutable
class Constants {
  static const expenseSymbol = '-';
  static const incomeSymbol = '+';
  static const transferSymbol = '⇄';

  static const expenseColor = 0xFFF44336;
  static const incomeColor = 0xFF4CAF50;
  static const transferColor = 0xFF9E9E9E;

  static const expenseIcon = Icons.arrow_downward;
  static const incomeIcon = Icons.arrow_upward;
  static const transferIcon = Icons.compare_arrows;

  static const selectCategory = 'Select Category';
  static const addAPhoto = 'Add a photo';
  static const writeANote = 'Write a note';
  static const newTransaction = 'New Transaction';
  static const editTransaction = 'Edit Transaction';

  const Constants._();
}

  // static const Iterable<Category> expenseCategories = [
  //   Category(
  //     name: 'Food',
  //     color: Color(0xFFC59B32),
  //     icon: Icon(Icons.restaurant),
  //     isSelected: true,
  //   ),
  //   Category(
  //     name: 'Transportation',
  //     color: Color(0xFFC59B32),
  //     icon: Icon(Icons.directions_bus),
  //   ),
  //   Category(
  //     name: 'Shopping',
  //     color: Color(0xFFC59B32),
  //     icon: Icon(Icons.shopping_cart),
  //   ),
  //   Category(
  //     name: 'Entertainment',
  //     color: Color(0xFFC59B32),
  //     icon: Icon(Icons.movie),
  //   ),
  //   Category(
  //     name: 'Health',
  //     color: Color(0xFFC59B32),
  //     icon: Icon(Icons.local_hospital),
  //   ),
  //   Category(
  //     name: 'Education',
  //     color: Color(0xFFC59B32),
  //     icon: Icon(Icons.school),
  //   ),
  //   Category(
  //     name: 'Others',
  //     color: Color(0xFFC59B32),
  //     icon: Icon(Icons.more_horiz),
  //   ),
  // ];

  // static const expenseStorageKey = 'expense';
  // static const incomeStorageKey = 'income';
  // static const transferStorageKey = 'transfer';


// num ExpenseCategory {
//   food(
//     category: Category(
//       name: 'Food',
//       color: Color(0xFFC59B32),
//       icon: Icon(Icons.restaurant),
//     ),
//   ),
//   transportation(
//     category: Category(
//       name: 'Transportation',
//       color: Color(0xFFC59B32),
//       icon: Icon(Icons.directions_bus),
//     ),
//   ),
//   shopping(
//     category: Category(
//       name: 'Shopping',
//       color: Color(0xFFC59B32),
//       icon: Icon(Icons.shopping_cart),
//     ),
//   ),
//   entertainment(
//     category: Category(
//       name: 'Entertainment',
//       color: Color(0xFFC59B32),
//       icon: Icon(Icons.movie),
//     ),
//   ),
//   health(
//     category: Category(
//       name: 'Health',
//       color: Color(0xFFC59B32),
//       icon: Icon(Icons.local_hospital),
//     ),
//   ),
//   education(
//     category: Category(
//       name: 'Education',
//       color: Color(0xFFC59B32),
//       icon: Icon(Icons.school),
//     ),
//   ),
//   others(
//     category: Category(
//       name: 'Others',
//       color: Color(0xFFC59B32),
//       icon: Icon(Icons.more_horiz),
//     ),
//   );

//   final Category category;

//   const ExpenseCategory({
//     required this.category,
//   });
// }
