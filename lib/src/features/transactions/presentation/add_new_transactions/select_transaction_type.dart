import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/category/application/category_services.dart';
import 'package:pocketfi/src/features/transactions/application/transaction_services.dart';
import 'package:pocketfi/src/utils/haptic_feedback_service.dart';

class SelectTransactionType extends ConsumerStatefulWidget {
  const SelectTransactionType({
    super.key,
    required this.noOfTabs,
  });

  final int noOfTabs;

  @override
  SelectTransactionTypeState createState() => SelectTransactionTypeState();
}

class SelectTransactionTypeState extends ConsumerState<SelectTransactionType>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.noOfTabs, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool get isSelectedTransactionNull =>
      (ref.watch(selectedTransactionProvider)?.date == null);

  // setOrUpdateTransactionType
  void setOrUpdateTransactionType(int newIndex) {
    if (isSelectedTransactionNull) {
      ref.read(transactionTypeProvider.notifier).setTransactionType(newIndex);
    } else {
      ref
          .read(selectedTransactionProvider.notifier)
          .updateTransactionType(newIndex, ref);

      // ! newly added
      // * update the category list
      final tabIndex = ref.watch(selectedTransactionProvider)?.type ??
          ref.watch(transactionTypeProvider);

      ref.read(categoriesProvider.notifier).updateCategoriesList(tabIndex!);

      // ! newly added
      // if (ref.read(categoriesProvider).isNotEmpty) {
      //   ref
      //       .read(selectedTransactionProvider.notifier)
      //       .updateCategory(ref.read(categoriesProvider).first, ref);
      // } else {
      //   ref
      //       .read(selectedTransactionProvider.notifier)
      //       .updateCategory(null, ref);
      // }

      ref.read(selectedTransactionProvider.notifier).updateCategory(
            (ref.read(categoriesProvider).isNotEmpty)
                ? ref.read(categoriesProvider).first
                : null,
            ref,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final tabIndex = ref.watch(transactionTypeProvider);

// * if user clicks on an existing transaction, then show the selected transaction's type
// * else, just default to first tab (expense)
    final tabIndex = ref.watch(selectedTransactionProvider)?.type ??
        ref.watch(transactionTypeProvider);

    Future.delayed(
      Duration.zero,
      () {
        // * gets the appropriate category list based on the transaction type
        // final type = ref.read(selectedTransactionProvider)?.type;
        // * get category list based on transaction type
        final selectedCategoryName = ref.read(selectedCategoryProvider).name;
        debugPrint('cat: $selectedCategoryName');
        ref.read(categoriesProvider.notifier).updateCategoriesList(tabIndex!);

        // * if selected category is not in the new category list, then reset it

        // if (type != null) {
        //   if (!ref
        //       .read(categoriesProvider)
        //       .any((element) => element.name == selectedCategoryName)) {
        //     resetCategoryState(ref);
        //   }
        // }
      },
    );
    return Transform.scale(
      scale: 0.9,
      child: DefaultTabController(
        length: widget.noOfTabs,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 45.0,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Consumer(
                  builder: (context, watch, child) {
                    return TabBar(
                      indicator: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        color: AppColors.mainColor1,
                      ),
                      labelColor: AppColors.white,
                      unselectedLabelColor: AppColors.mainColor1,
                      tabs: [
                        const Tab(text: Strings.expense),
                        const Tab(text: Strings.income),
                        if (widget.noOfTabs == 3)
                          const Tab(text: Strings.transfer),
                      ],
                      onTap: (index) {
                        // ref
                        //     .read(transactionTypeProvider.notifier)
                        //     .setTransactionType(index);
                        HapticFeedbackService.lightImpact();
                        setOrUpdateTransactionType(index);

                        final indexSelected = ref.read(transactionTypeProvider);
                        debugPrint('index selected: $indexSelected');
                      },
                      controller: _tabController,
                      // controller: TabController(
                      //   length: widget.noOfTabs,
                      //   initialIndex: tabIndex!.index,
                      //   vsync: this,
                      // ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// if noOfTabs is 2, dun show transfer tab (2 tabs total)
// if noOfTabs is 3, show transfer tab (3 tabs total)
// if (widget.noOfTabs == 2) {
//   return Transform.scale(
//     scale: 0.9,
//     child: DefaultTabController(
//       length: widget.noOfTabs,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Container(
//               height: 45.0,
//               decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 1,
//                     blurRadius: 5,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(25.0),
//               ),
//               child: Consumer(
//                 builder: (context, watch, child) {
//                   return TabBar(
//                     indicator: const BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                       color: AppColors.mainColor1,
//                     ),
//                     labelColor: AppColors.white,
//                     unselectedLabelColor: AppColors.mainColor1,
//                     tabs: const [
//                       Tab(text: Strings.expense),
//                       Tab(text: Strings.income),
//                       // Tab(text: Strings.transfer),
//                     ],
//                     onTap: (index) {
//                       ref
//                           .read(transactionTypeProvider.notifier)
//                           .setTransactionType(index);

//                       final indexSelected =
//                           ref.read(transactionTypeProvider);
//                       debugPrint('index selected: $indexSelected');
//                     },
//                     controller: TabController(
//                       length: widget.noOfTabs,
//                       initialIndex: tabIndex.index,
//                       vsync: this,
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
