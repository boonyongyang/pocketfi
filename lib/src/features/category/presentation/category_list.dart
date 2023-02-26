//todo this should be the one to represent each tile for the category list --> since GridView can't customise length i think, 

// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:pocketfi/state/category/providers/category_provider.dart';

// class CategoryList extends ConsumerWidget {
//   const CategoryList({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final categories = ref.watch(expenseCategoriesProvider);

//     return Wrap(
//       spacing: 8,
//       children: categories.map((category) {
//         return GestureDetector(
//           onTap: () {
//             ref
//                 .read(expenseCategoriesProvider)
//                 .setCategory(category, !category.isSelected);
//           },
//           child: CircleAvatar(
//             backgroundColor: category.color,
//             child: category.icon,
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
