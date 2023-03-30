import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/debts/domain/debt.dart';
import 'package:pocketfi/src/features/debts/presentation/debt_data_table.dart';

// import 'update_debt_view.dart';

class DebtOverviewView extends ConsumerStatefulWidget {
  final Debt debt;

  const DebtOverviewView({
    Key? key,
    required this.debt,
  }) : super(key: key);

  @override
  DebtOverviewViewState createState() => DebtOverviewViewState();
}

class DebtOverviewViewState extends ConsumerState<DebtOverviewView> {
  @override
  Widget build(BuildContext context) {
    int totalMonths =
        widget.debt.totalNumberOfMonthsToPay; // for example, 32 months
    int years = totalMonths ~/ 12; // get the number of years
    int months = totalMonths % 12; // get the remaining months

    String monthsNYears =
        '$years years $months months'; // combine years and months into a string
// print(result); // output: "2 years and 8 months"

    // final selectedDebt = ref.watch(selectedDebtProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                bottom: 8.0,
                left: 8.0,
                right: 8.0,
              ),
              child: Container(
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
                      offset: const Offset(3, 6), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                    8.0,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Years to Finish Paying',
                            style: TextStyle(
                              color: AppColors.mainColor1,
                              fontWeight: FontWeight.bold,
                            ),
                            // textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       '${widget.debt.totalNumberOfMonthsToPay} months',
                      //       // widget.debt.debtAmount.toStringAsFixed(2),
                      //       style: const TextStyle(
                      //         color: AppColors.mainColor2,
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 30,
                      //       ),
                      //       // textAlign: TextAlign.center,
                      //     ),
                      //   ],
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            monthsNYears,
                            // widget.debt.debtAmount.toStringAsFixed(2),
                            style: const TextStyle(
                              color: AppColors.mainColor2,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                            // textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(
                8.0,
              ),
              child: Container(
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
                      offset: const Offset(3, 6), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                    8.0,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 8.0,
                      bottom: 8.0,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Debt Amount',
                              style: TextStyle(
                                color: AppColors.mainColor1,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'MYR ${widget.debt.debtAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppColors.mainColor1,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Annual Interest Rate',
                              style: TextStyle(
                                color: AppColors.mainColor1,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${widget.debt.annualInterestRate.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                color: AppColors.mainColor1,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Minumum Payment Per Month',
                              style: TextStyle(
                                color: AppColors.mainColor1,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'MYR ${widget.debt.minimumPayment.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppColors.mainColor1,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(
                        //   height: 8.0,
                        // ),
                        const Divider(),
                        Row(
                          children: [
                            const Text(
                              'Total Amount',
                              style: TextStyle(
                                color: AppColors.mainColor1,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'MYR ${widget.debt.calculateTotalPayment().toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppColors.mainColor1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
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
                      offset: const Offset(3, 6), // changes position of shadow
                    ),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('should show a graph here'),
                ),
                // SfCircularChart(
                //     title: ChartTitle(text: 'Expenses by Category'),
                //     legend: Legend(
                //       isVisible: true,
                //       position: LegendPosition.bottom,
                //       overflowMode: LegendItemOverflowMode.wrap,
                //       textStyle: const TextStyle(fontSize: 14),
                //     ),
                //     tooltipBehavior: TooltipBehavior(enable: true),
                //     series: <CircularSeries>[
                //               // Renders radial bar chart
                //               RadialBarSeries<ChartData, String>(
                //                   dataSource: <ChartData>[
                //                       ChartData('Food', 35),
                //                       ChartData('Travel', 15),
                //                       ChartData('Shopping', 25),
                //                       ChartData('Bills', 25),
                //                   ],
                //                   xValueMapper: (ChartData data, _) => data.x,
                //                   yValueMapper: (ChartData data, _) => data.y
                //               )
                //     ]
                // series: <CircularSeries<ExpenseData, String>>[
                // series: <DoughnutSeries<ExpenseData, String>>[
                //   DoughnutSeries<ExpenseData, String>(
                //     dataSource: data,
                //     xValueMapper: (ExpenseData sales, _) => sales.category,
                //     yValueMapper: (ExpenseData sales, _) => sales.percentage,
                //     dataLabelSettings: const DataLabelSettings(
                //       isVisible: true,
                //       labelPosition: ChartDataLabelPosition.inside,
                //       textStyle: TextStyle(
                //           fontSize: 14.0,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.white,
                //           fontFamily: 'Roboto'),
                //     ),
                //   )
                // ],
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DebtDataTable(
                      debt: widget.debt,
                    ),
                  ),
                );
              },
              //   shape: const RoundedRectangleBorder(
              //   borderRadius: BorderRadius.all(
              //     Radius.circular(30),
              //   ),
              // ),
              child: const SizedBox(
                child: Text('View Overall Payment Table'),
              ),
            ),
            // ),
            // PaginatedDataTable(
            //   // header: const Text('TableFormDebt'),
            //   columns: const [
            //     DataColumn(label: Text('Month')),
            //     DataColumn(label: Text('Interest')),
            //     DataColumn(label: Text('Principle')),
            //     DataColumn(label: Text('End Balance')),
            //   ],
            //   columnSpacing: 35,
            //   source: _TableDataSource(tableData),
            //   rowsPerPage: 20,
            // ),
          ],
        ),
      ),
    );
  }

  int calculateDebtLoanDuration({
    required double totalDebtAmount,
    required double minPaymentPerMonth,
    required double annualInterestRate,
  }) {
    // double totalDebtAmount = 3000;
    // double minPaymentPerMonth = 200;
    // double annualInterestRate = 6.0;

    double endBalance = totalDebtAmount;
    double monthlyInterestRate = (annualInterestRate / 100) / 12;
    double interest = 0;
    double principle = 0;
    int months = 0;

    while (endBalance > 0 && endBalance > minPaymentPerMonth) {
      interest = endBalance * monthlyInterestRate;
      debugPrint('minumum payment: $minPaymentPerMonth');

      endBalance = endBalance + interest - minPaymentPerMonth;
      principle = minPaymentPerMonth - interest;
      months++;
      debugPrint('Total months: $months');
      debugPrint('Interest: $interest');
      debugPrint('endBalance: $endBalance');
      debugPrint('principle: $principle');
    }
    interest = endBalance * monthlyInterestRate;
    principle = endBalance;
    endBalance = 0.00;
    months++;
    debugPrint('Total months after : $months');
    debugPrint('Total principle: $principle');
    return months;
  }
}

// class _TableDataSource extends DataTableSource {
//   _TableDataSource(this._tableData);

//   final List<Map<String, dynamic>> _tableData;

//   @override
//   DataRow? getRow(int index) {
//     if (index >= _tableData.length) {
//       return null;
//     }

//     final rowData = _tableData[index];

//     return DataRow.byIndex(
//       index: index,
//       cells: [
//         DataCell(Text('${rowData['month']}')),
//         DataCell(Text('${rowData['interest']}')),
//         DataCell(Text('${rowData['principle']}')),
//         DataCell(Text('${rowData['endBalance']}')),
//       ],
//     );
//   }

//   @override
//   int get rowCount => _tableData.length;

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get selectedRowCount => 0;
// }
