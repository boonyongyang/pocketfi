import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/category/application/category_providers.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/timeline/bills/application/bill_services.dart';
import 'package:pocketfi/src/features/timeline/bills/domain/bill.dart';
import 'package:pocketfi/src/features/timeline/bills/presentation/bill_list_view.dart';
import 'package:pocketfi/src/features/timeline/bills/presentation/create_new_bill_page.dart';
import 'package:pocketfi/src/features/timeline/transactions/data/transaction_notifiers.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BillsTabView extends ConsumerWidget {
  const BillsTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userBills = ref.watch(userBillsProvider);
    final categories = ref.watch(expenseCategoriesProvider);
    double amount = 0.0;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
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
                      dataSource: categories,
                      xValueMapper: (Category category, _) => category.name,
                      yValueMapper: (Category category, _) {
                        return userBills.when(
                          data: (bills) {
                            final categoryBills = bills.where(
                                (bill) => bill.categoryName == category.name);
                            final totalAmount =
                                getTotalAmount(categoryBills.toList());
                            amount = totalAmount;
                            return totalAmount;
                          },
                          loading: () => 0,
                          error: (error, stackTrace) {
                            debugPrint(error.toString());
                            return 0;
                          },
                        );
                      },
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.inside,
                        textStyle: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      pointRenderMode: PointRenderMode.segment,
                      enableTooltip: true,
                      emptyPointSettings: EmptyPointSettings(
                        mode: EmptyPointMode.gap,
                      ),
                      // only show the label that has value, if the value is 0, then don't show the label
                      // dataLabelMapper: (Category category, _) {
                      //   final totalAmount = yValueMapper(category, null);
                      //   return totalAmount > 0
                      //       ? '\$${totalAmount.toStringAsFixed(2)}'
                      //       : '';
                      // },
                    ),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.white,
              backgroundColor: AppColors.mainColor1,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
            ),
            onPressed: () {
              setNewTransactionState(ref);
              setBillCategory(ref);
              Navigator.of(context, rootNavigator: true).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const CreateNewBillPage(),
                  transitionDuration: const Duration(milliseconds: 200),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    final curvedAnimation = CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeIn,
                      reverseCurve: Curves.easeIn,
                    );
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(curvedAnimation),
                      child: child,
                    );
                  },
                ),
              );
            },
            child: const Text('Add Bill'),
          ),
          RefreshIndicator(
            onRefresh: () {
              ref.refresh(userBillsProvider);
              return Future.delayed(
                const Duration(
                  milliseconds: 500,
                ),
              );
            },
            child: userBills.when(
              data: (bills) {
                if (bills.isEmpty) {
                  return const EmptyContentsWithTextAnimationView(
                    text: Strings.youHaveNoPosts,
                  );
                } else {
                  return BillListView(
                    bills: bills,
                  );
                }
              },
              error: (error, stackTrace) {
                return const ErrorAnimationView();
              },
              loading: () {
                return const LoadingAnimationView();
              },
            ),
          ),
        ],
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
