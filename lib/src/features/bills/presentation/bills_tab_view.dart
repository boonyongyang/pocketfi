import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/bills/application/bill_services.dart';
import 'package:pocketfi/src/features/bills/presentation/bill_history_list_view.dart';
import 'package:pocketfi/src/features/bills/presentation/bill_upcoming_list_view.dart';
import 'package:pocketfi/src/features/bills/presentation/select_bill_tab.dart';
import 'package:pocketfi/src/features/category/application/category_services.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/bills/data/bill_repository.dart';
import 'package:pocketfi/src/features/bills/domain/bill.dart';
import 'package:pocketfi/src/features/bills/presentation/add_new_bill.dart';
import 'package:pocketfi/src/features/transactions/application/transaction_services.dart';
import 'package:pocketfi/src/features/shared/date_picker/application/date_services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BillsTabView extends ConsumerWidget {
  const BillsTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billTabIndex = ref.watch(billTabIndexProvider);
    final userBills = ref.watch(userBillsProvider);
    final categories = ref.watch(expenseCategoriesProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    final filteredCategories = categories.where(
      (category) => userBills.when(
        data: (bills) => bills.any(
          (bill) => bill.categoryName == category.name,
        ),
        loading: () => false,
        error: (error, stackTrace) {
          debugPrint(error.toString());
          return false;
        },
      ),
    );

    final isBillListEmpty = userBills.when(
      data: (bills) => bills.isEmpty,
      loading: () => false,
      error: (error, stackTrace) {
        debugPrint(error.toString());
        return false;
      },
    );

    return RefreshIndicator(
      onRefresh: () {
        ref.refresh(userBillsProvider);
        ref.refresh(overviewMonthProvider.notifier).resetMonth();
        debugPrint('refresh bills');
        return Future.delayed(const Duration(milliseconds: 500));
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const SizedBox(height: 20.0),
            Column(
              children: [
                Visibility(
                  visible: !isBillListEmpty,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // const MonthPicker(),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          height: screenHeight * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(2, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: SfCircularChart(
                              title: ChartTitle(text: 'Bills by Category'),
                              legend: Legend(
                                isVisible: true,
                                position: LegendPosition.bottom,
                                overflowMode: LegendItemOverflowMode.wrap,
                                textStyle: const TextStyle(fontSize: 14),
                              ),
                              tooltipBehavior: TooltipBehavior(enable: true),
                              series: <DoughnutSeries<Category, String>>[
                                DoughnutSeries<Category, String>(
                                  dataSource: filteredCategories.toList(),
                                  // dataSource: categoriesList,
                                  xValueMapper: (Category category, _) =>
                                      category.name,
                                  yValueMapper: (Category category, _) {
                                    return userBills.when(
                                      data: (transactions) {
                                        final categoryTransactions =
                                            transactions.where((tran) =>
                                                tran.categoryName ==
                                                category.name);
                                        final totalAmount = getTotalAmount(
                                            categoryTransactions.toList());
                                        return totalAmount;
                                      },
                                      loading: () => 0,
                                      error: (error, stackTrace) {
                                        debugPrint(error.toString());
                                        return 0;
                                      },
                                    );
                                  },
                                  pointColorMapper: (Category category, _) =>
                                      category.color,
                                  dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                    labelPosition:
                                        ChartDataLabelPosition.outside,
                                    textStyle: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.mainColor1,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  dataLabelMapper: (Category category, _) {
                                    final totalAmount = userBills.when(
                                      data: (transactions) {
                                        final categoryTransactions =
                                            transactions.where((tran) =>
                                                tran.categoryName ==
                                                category.name);
                                        if (categoryTransactions.isEmpty) {
                                          return null;
                                        }
                                        final categoryTotalAmount =
                                            getTotalAmount(
                                                categoryTransactions.toList());
                                        final totalAmount = getTotalAmount(
                                            transactions.toList());
                                        final percentage = totalAmount > 0
                                            ? (categoryTotalAmount /
                                                    totalAmount *
                                                    100)
                                                .toStringAsFixed(1)
                                            : '0.0';
                                        return '$percentage%';
                                        // return '${category.name}: $percentage%';
                                      },
                                      loading: () => null,
                                      error: (error, stackTrace) {
                                        debugPrint(error.toString());
                                        return null;
                                      },
                                    );
                                    return totalAmount;
                                  },
                                  pointRenderMode: PointRenderMode.segment,
                                  enableTooltip: true,
                                  emptyPointSettings: EmptyPointSettings(
                                    mode: EmptyPointMode.gap,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 0.35, 55),
                        backgroundColor: AppColors.mainColor2,
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                      ),
                      onPressed: () {
                        setNewTransactionState(ref);
                        setBillCategory(ref);
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => const AddNewBill(),
                          ),
                        );
                        // Navigator.of(context, rootNavigator: true).push(
                        //   PageRouteBuilder(
                        //     pageBuilder:
                        //         (context, animation, secondaryAnimation) =>
                        //             const AddNewBill(),
                        //     transitionDuration:
                        //         const Duration(milliseconds: 200),
                        //     transitionsBuilder: (context, animation,
                        //         secondaryAnimation, child) {
                        //       final curvedAnimation = CurvedAnimation(
                        //         parent: animation,
                        //         curve: Curves.easeIn,
                        //         reverseCurve: Curves.easeIn,
                        //       );
                        //       return SlideTransition(
                        //         position: Tween<Offset>(
                        //           begin: const Offset(0, 1),
                        //           end: Offset.zero,
                        //         ).animate(curvedAnimation),
                        //         child: child,
                        //       );
                        //     },
                        //   ),
                        // );
                      },
                      child: const SizedBox(
                        child: Text(
                          'Add Bill',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(thickness: 0),
                const SelectBillTab(),
                if (billTabIndex == 0)
                  BillUpcomingListView(userBills: userBills),
                if (billTabIndex == 1)
                  BillHistoryListView(userBills: userBills),
              ],
            ),
            const SizedBox(height: 150.0),
          ],
        ),
      ),
    );
  }

  double getTotalAmount(List<Bill> bills) {
    return bills.fold<double>(
      0,
      (previousValue, element) => previousValue + element.amount,
    );
  }
}

// class BillsTabView extends ConsumerWidget {
//   const BillsTabView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final billTabIndex = ref.watch(billTabIndexProvider);
//     // final userBills = ref.watch(userBillsProvider);
//     final userBills = ref.watch(currentMonthBillsProvider);
//     final userMonthlyBills = ref.watch(userMonthlyBillsProvider);
//     final categories = ref.watch(expenseCategoriesProvider);
//     final screenHeight = MediaQuery.of(context).size.height;

// // filteredCategory where only get categories from
//     final filteredCategories = ref.watch(filteredBillCategoriesProvider);

//     // // filter bills by month
//     // final filteredBills = userBills.when(
//     //   data: (bills) {
//     //     final month = ref.watch(overviewMonthProvider);
//     //     return bills.where((bill) => bill.dueDate.month == month.month);
//     //   },
//     //   loading: () => [],
//     //   error: (error, stackTrace) {
//     //     debugPrint(error.toString());
//     //     return [];
//     //   },
//     // );

//     return RefreshIndicator(
//       onRefresh: () {
//         ref.refresh(userBillsProvider);
//         ref.refresh(overviewMonthProvider.notifier).resetMonth();
//         debugPrint('refresh bills');
//         return Future.delayed(const Duration(milliseconds: 500));
//       },
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const SizedBox(height: 20.0),
//             Column(
//               children: [
//                 Visibility(
//                   visible: userBills.isNotEmpty,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const MonthPicker(),
//                       Padding(
//                         padding: const EdgeInsets.all(20.0),
//                         child: Container(
//                           height: screenHeight * 0.4,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: const BorderRadius.all(
//                               Radius.circular(20),
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.5),
//                                 spreadRadius: 2,
//                                 blurRadius: 7,
//                                 offset: const Offset(2, 4),
//                               ),
//                             ],
//                           ),
//                           child: Center(
//                             child: SfCircularChart(
//                               title: ChartTitle(text: 'Bills by Category'),
//                               legend: Legend(
//                                 isVisible: true,
//                                 position: LegendPosition.bottom,
//                                 overflowMode: LegendItemOverflowMode.wrap,
//                                 textStyle: const TextStyle(fontSize: 14),
//                               ),
//                               tooltipBehavior: TooltipBehavior(enable: true),
//                               series: <DoughnutSeries<Category, String>>[
//                                 DoughnutSeries<Category, String>(
//                                   dataSource: filteredCategories,
//                                   // dataSource: categoriesList,
//                                   xValueMapper: (Category category, _) =>
//                                       category.name,
//                                   yValueMapper: (Category category, _) {
//                                     return ref.read(
//                                       billCategoryTotalAmountForCurrentMonthProvider(
//                                         category.name,
//                                       ),
//                                     );
//                                   },
//                                   pointColorMapper: (Category category, _) =>
//                                       category.color,
//                                   dataLabelSettings: const DataLabelSettings(
//                                     isVisible: true,
//                                     labelPosition:
//                                         ChartDataLabelPosition.outside,
//                                     textStyle: TextStyle(
//                                       fontSize: 14.0,
//                                       fontWeight: FontWeight.bold,
//                                       color: AppColors.mainColor1,
//                                       fontFamily: 'Roboto',
//                                     ),
//                                   ),
//                                   dataLabelMapper: (Category category, _) {
//                                     final totalTypeAmount =
//                                         ref.watch(totalTypeAmountProvider);

//                                     final categoryTotalAmount = ref.read(
//                                       billCategoryTotalAmountForCurrentMonthProvider(
//                                         category.name,
//                                       ),
//                                     );

//                                     final percentage = totalTypeAmount > 0
//                                         ? (categoryTotalAmount /
//                                                 totalTypeAmount *
//                                                 100)
//                                             .toStringAsFixed(1)
//                                         : '0.0';
//                                     return '$percentage%';
//                                   },
//                                   pointRenderMode: PointRenderMode.segment,
//                                   enableTooltip: true,
//                                   emptyPointSettings: EmptyPointSettings(
//                                     mode: EmptyPointMode.gap,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         fixedSize:
//                             Size(MediaQuery.of(context).size.width * 0.35, 55),
//                         backgroundColor: AppColors.mainColor2,
//                         foregroundColor: Colors.white,
//                         shape: const RoundedRectangleBorder(
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(30),
//                           ),
//                         ),
//                       ),
//                       onPressed: () {
//                         setNewTransactionState(ref);
//                         setBillCategory(ref);
//                         Navigator.of(context, rootNavigator: true).push(
//                           PageRouteBuilder(
//                             pageBuilder:
//                                 (context, animation, secondaryAnimation) =>
//                                     const AddNewBill(),
//                             transitionDuration:
//                                 const Duration(milliseconds: 200),
//                             transitionsBuilder: (context, animation,
//                                 secondaryAnimation, child) {
//                               final curvedAnimation = CurvedAnimation(
//                                 parent: animation,
//                                 curve: Curves.easeIn,
//                                 reverseCurve: Curves.easeIn,
//                               );
//                               return SlideTransition(
//                                 position: Tween<Offset>(
//                                   begin: const Offset(0, 1),
//                                   end: Offset.zero,
//                                 ).animate(curvedAnimation),
//                                 child: child,
//                               );
//                             },
//                           ),
//                         );
//                       },
//                       child: const SizedBox(
//                         child: Text(
//                           'Add Bill',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 17,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const Divider(thickness: 0),
//                 const SelectBillTab(),
//                 if (billTabIndex == 0)
//                   BillUpcomingListView(userBills: userMonthlyBills),
//                 if (billTabIndex == 1)
//                   BillHistoryListView(userBills: userMonthlyBills),
//               ],
//             ),
//             const SizedBox(height: 150.0),
//           ],
//         ),
//       ),
//     );
//   }

//   double getTotalAmount(List<Bill> bills) {
//     return bills.fold<double>(
//       0,
//       (previousValue, element) => previousValue + element.amount,
//     );
//   }
// }
