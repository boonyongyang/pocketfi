import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/category/data/category_repository.dart';
import 'package:pocketfi/src/features/debts/data/debt_payment_repository.dart';
import 'package:pocketfi/src/features/debts/domain/debt.dart';
import 'package:pocketfi/src/features/debts/presentation/debt_data_table.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
    var totalAmountPaid = 0.0;
    // var totalInterestPaid = 0.0;

    final debtPaymentsList = ref.watch(userDebtPaymentsProvider).value;
    if (debtPaymentsList != null) {
      for (var debtPayment in debtPaymentsList) {
        if (debtPayment.debtId == widget.debt.debtId) {
          totalAmountPaid +=
              debtPayment.principleAmount + debtPayment.interestAmount;
        }
        // totalInterestPaid += debtPayment.interestAmount;
      }
    }

    var percentagePaid =
        totalAmountPaid / widget.debt.calculateTotalPayment() * 100;

    // final selectedDebt = ref.watch(selectedDebtProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                // bottom: 8.0,
                left: 16.0,
                right: 16.0,
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
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
              padding: const EdgeInsets.only(
                top: 16.0,
                left: 16.0,
                right: 16.0,
              ),
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
                      offset: const Offset(3, 6), // changes position of shadow
                    ),
                  ],
                ),
                child: SfRadialGauge(
                  title: const GaugeTitle(
                    text: 'Payoff Progress',
                    textStyle: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  axes: <RadialAxis>[
                    RadialAxis(
                      // radiusFactor: 0.55,
                      startAngle: 270,
                      endAngle: 270,
                      minimum: 0,
                      maximum: 100,
                      showLabels: false,
                      showTicks: false,
                      axisLineStyle: AxisLineStyle(
                        thickness: 0.2,
                        color: Colors.grey[300],
                        thicknessUnit: GaugeSizeUnit.factor,
                      ),
                      pointers: [
                        RangePointer(
                          color: colorList[widget.debt.debtAmount.toInt() %
                              colorList.length],
                          value: percentagePaid,
                          cornerStyle: CornerStyle.bothCurve,
                          width: 0.2,
                          sizeUnit: GaugeSizeUnit.factor,
                        ),
                      ],
                      annotations: [
                        GaugeAnnotation(
                          widget: Text(
                            '${percentagePaid.toStringAsFixed(2)}%',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: colorList[widget.debt.debtAmount.toInt() %
                                  colorList.length],
                            ),
                          ),
                          angle: 90,
                          positionFactor: 0.1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                left: 16.0,
                right: 16.0,
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
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // fixedSize: Size(80, 30),
                  backgroundColor: AppColors.mainColor1,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                ),
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
                child: const SizedBox(
                  child: Text('View Overall Payment Table'),
                ),
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
