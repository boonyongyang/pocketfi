// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:pocketfi/state/category/models/category.dart';
// import 'package:pocketfi/state/category/notifiers/category_state_notifier.dart';
// import 'package:pocketfi/state/category/providers/category_provider.dart';

// class AddNewExpensePage extends ConsumerWidget {
//   const AddNewExpensePage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final categories = ref.watch(expenseCategoriesProvider);
//     final selectedCategory = ref.watch(selectedCategoryProvider);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Add New Expense')),
//       body: Column(
//         children: [
//           DropdownButton<Category>(
//             value: selectedCategory,
//             items: categories
//                 .map((category) => DropdownMenuItem<Category>(
//                       value: category,
//                       child: CircleAvatar(
//                         backgroundColor: category.color,
//                         child: category.icon,
//                       ),
//                     ))
//                 .toList(),
//             onChanged: (Category? category) {
//               ref.read(selectedCategoryProvider.notifier).state = category!;
//             },
//           ),
//           // Wrap(
//           //   spacing: 8,
//           //   children: categories.map((category) {
//           //     return GestureDetector(
//           //       onTap: () {
//           //         ref.read(selectedCategoryProvider.notifier).state = category;
//           //       },
//           //       child: CircleAvatar(
//           //         backgroundColor: category.color,
//           //         child: category.icon,
//           //       ),
//           //     );
//           //   }).toList(),
//           // ),
//         ],
//       ),
//     );
//   }
// }
