
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/category/data/category_repository.dart';
import 'package:pocketfi/src/features/debts/data/debt_repository.dart';
import 'package:pocketfi/src/features/debts/domain/debt.dart';
import 'package:pocketfi/src/features/debts/presentation/add_new_debt.dart';
import 'package:pocketfi/src/features/debts/presentation/debt_details_view.dart';
import 'package:pocketfi/src/features/debts/presentation/debt_tiles.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DebtTabView extends ConsumerWidget {
  const DebtTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debts = ref.watch(userDebtsProvider);
    // Color randomColor = colorList[Random().nextInt(colorList.length)];

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(userDebtsProvider);
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Visibility(
                  visible: debts.value?.isNotEmpty ?? false,
                  child: Container(
                      padding: const EdgeInsets.all(10.0),
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
                            offset: const Offset(
                                3, 6), // changes position of shadow
                          ),
                        ],
                      ),
                      height: MediaQuery.of(context).size.height * 0.4,
                      // add circular progress indicator
                      child: debts.when(
                        data: (debts) {
                          // return Padding(
                          //   padding: const EdgeInsets.all(32.0),
                          //   child: CircularProgressIndicator(
                          //     valueColor: const AlwaysStoppedAnimation<Color>(
                          //       AppColors.mainColor2,
                          //     ),
                          //     value: 0.4,
                          //     backgroundColor: Colors.grey[300],
                          //     strokeWidth: 50.0,
                          //   ),
                          // );
                          return SfCircularChart(
                            title: ChartTitle(text: 'Debt Summary'),
                            legend: Legend(
                              isVisible: true,
                              position: LegendPosition.bottom,
                              overflowMode: LegendItemOverflowMode.wrap,
                              textStyle: const TextStyle(fontSize: 14),
                            ),
                            annotations: [
                              CircularChartAnnotation(
                                widget: Text(
                                  'MYR ${debts.isEmpty ? '0.00' : debts.map((e) => e.calculateTotalPayment()).reduce((value, element) => value + element).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.mainColor1,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ),
                            ],
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <DoughnutSeries<Debt, String>>[
                              DoughnutSeries<Debt, String>(
                                radius: '100%',
                                innerRadius: '65%',
                                dataSource: debts.toList(),
                                xValueMapper: (Debt debt, _) => debt.debtName,
                                yValueMapper: (Debt debt, _) =>
                                    debt.calculateTotalPayment(),
                                pointColorMapper: (Debt debt, _) =>
                                    // Colors.pink[100 * debt.debtAmount.toInt()],
                                    colorList[debt.debtAmount.toInt() %
                                        colorList.length],
                                // colorList[
                                //     Random().nextInt(colorList.length)],
                                // randomColor,
                                dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  labelPosition: ChartDataLabelPosition.outside,
                                  textStyle: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.mainColor1,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                dataLabelMapper: (Debt debt, _) {
                                  final totalAmount = (() {
                                    if (debts.isEmpty) {
                                      return 0.0;
                                    } else {
                                      return debts
                                          .map((e) => e.debtAmount)
                                          .reduce((value, element) =>
                                              value + element);
                                    }
                                  })();
                                  final debtTotalAmount = debt.debtAmount;
                                  final percentage = totalAmount > 0
                                      ? (debtTotalAmount / totalAmount * 100)
                                          .toStringAsFixed(1)
                                      : '0.0';
                                  return '$percentage%';
                                  // return 'MYR ${debt.calculateTotalPayment().toStringAsFixed(2)}';
                                },
                                pointRenderMode: PointRenderMode.segment,
                                enableTooltip: true,
                                emptyPointSettings: EmptyPointSettings(
                                  mode: EmptyPointMode.gap,
                                ),
                              ),
                            ],
                          );
                        },
                        loading: () => const LoadingAnimationView(),
                        error: (error, stack) => const ErrorAnimationView(),
                      )),
                ),
              ),
            ),
            // SliverToBoxAdapter(
            //   child: SizedBox(height: 10),
            // ),
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.35, 55),
                          backgroundColor: AppColors.mainColor2,
                          foregroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => const AddNewDebt(),
                            ),
                          );
                        },
                        child: const SizedBox(
                          child: Text(
                            'Add Debt',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width * 0.1,
                  // ),
                  // SizedBox(
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         fixedSize: Size(
                  //             MediaQuery.of(context).size.width * 0.35, 55),
                  //         backgroundColor: AppColors.mainColor1,
                  //         foregroundColor: Colors.white,
                  //         shape: const RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.all(
                  //             Radius.circular(30),
                  //           ),
                  //         ),
                  //       ),
                  //       onPressed: () {},
                  //       child: const SizedBox(
                  //         child: Text(
                  //           'Track',
                  //           textAlign: TextAlign.center,
                  //           style: TextStyle(
                  //             fontSize: 17,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            debts.when(
              data: (debts) {
                if (debts.isNotEmpty) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final debt = debts.elementAt(index);
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: DebtTiles(
                            debt: debt,
                            circleAvatarColor:
                                // Colors.pink[500 * debt.debtAmount.toInt()],
                                // Colors.primaries[debt.debtAmount.toInt() %
                                //     Colors.primaries.length],

                                colorList[
                                    debt.debtAmount.toInt() % colorList.length],
                            // colorList[Random().nextInt(colorList.length)],
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (context) => DebtDetailsView(
                                    debt: debt,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      childCount: debts.length,
                    ),
                  );
                } else {
                  return const SliverToBoxAdapter(
                    child: EmptyContentsWithTextAnimationView(
                      text:
                          '\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t No debts yet. \n Click the button to add a debt.',
                      // 'No debts yet.\nClick the button to add a debt.',
                    ),
                  );
                }
              },
              loading: () => const SliverToBoxAdapter(
                child: LoadingAnimationView(),
              ),
              error: (error, stackTrace) => const SliverToBoxAdapter(
                child: ErrorAnimationView(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
