import 'package:flutter/material.dart';
import 'package:pocketfi/src/features/debts/domain/debt.dart';

// import 'update_debt_view.dart';

class DebtDataTable extends StatefulWidget {
  final Debt debt;

  const DebtDataTable({
    Key? key,
    required this.debt,
  }) : super(key: key);

  @override
  _DebtDataTableState createState() => _DebtDataTableState();
}

class _DebtDataTableState extends State<DebtDataTable> {
  late List<Map<String, dynamic>> tableData;

  @override
  void initState() {
    super.initState();
    tableData = widget.debt.debtLoanInTable(
        // debtAmount: widget.debt.debtAmount,
        // minimumPayment: widget.debt.minimumPayment,
        // annualInterestRate: widget.debt.annualInterestRate,
        // createdAt: widget.debt.createdAt!,
        );
  }

  // List<Map<String, dynamic>> debtLoanInTable({
  //   required double totalDebtAmount,
  //   required double minPaymentPerMonth,
  //   required double annualInterestRate,
  //   required DateTime createdAt,
  // }) {
  //   int createdMonth = createdAt.month;

  //   double endBalance = totalDebtAmount;
  //   double monthlyInterestRate = (annualInterestRate / 100) / 12;
  //   double interest = 0;
  //   double principle = 0;
  //   int months = createdMonth - 1;

  //   List<Map<String, dynamic>> tableData = [];

  //   while (endBalance > 0 && endBalance > minPaymentPerMonth) {
  //     interest = endBalance * monthlyInterestRate;
  //     endBalance = endBalance + interest - minPaymentPerMonth;
  //     principle = minPaymentPerMonth - interest;
  //     months++;

  //     // int month = createdMonth + months;
  //     // if (month > 12) {
  //     //   month -= 12;
  //     // }
  //     String monthName = DateFormat('MMM yyyy').format(
  //       DateTime(createdAt.year, months),
  //     );
  //     Map<String, dynamic> rowData = {
  //       'month': monthName,
  //       'interest': interest.toStringAsFixed(2),
  //       'principle': principle.toStringAsFixed(2),
  //       'endBalance': endBalance.toStringAsFixed(2),
  //     };

  //     tableData.add(rowData);
  //   }

  //   interest = endBalance * monthlyInterestRate;
  //   principle = endBalance;
  //   endBalance = 0.00;
  //   months++;

  //   String monthName = DateFormat('MMM yyyy').format(
  //     DateTime(createdAt.year, months),
  //   );

  //   Map<String, dynamic> rowData = {
  //     'month': monthName,
  //     'interest': interest.toStringAsFixed(2),
  //     'principle': principle.toStringAsFixed(2),
  //     'endBalance': endBalance.toStringAsFixed(2),
  //   };

  //   tableData.add(rowData);

  //   return tableData;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("All Payments"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PaginatedDataTable(
              // header: const Text('DebtDataTable'),
              columns: const [
                DataColumn(label: Text('Month')),
                DataColumn(label: Text('Interest')),
                DataColumn(label: Text('Principle')),
                DataColumn(label: Text('End Balance')),
              ],
              columnSpacing: 30,
              source: _TableDataSource(tableData),
              rowsPerPage: 20,
            ),
          ],
        ),
      ),
    );
  }

  // int calculateDebtLoan({
  //   required double totalDebtAmount,
  //   required double minPaymentPerMonth,
  //   required double annualInterestRate,
  // }) {
  //   // double totalDebtAmount = 3000;
  //   // double minPaymentPerMonth = 200;
  //   // double annualInterestRate = 6.0;

  //   double endBalance = totalDebtAmount;
  //   double monthlyInterestRate = (annualInterestRate / 100) / 12;
  //   double interest = 0;
  //   double principle = 0;
  //   int months = 0;

  //   while (endBalance > 0 && endBalance > minPaymentPerMonth) {
  //     interest = endBalance * monthlyInterestRate;
  //     debugPrint('minumum payment: $minPaymentPerMonth');

  //     endBalance = endBalance + interest - minPaymentPerMonth;
  //     principle = minPaymentPerMonth - interest;
  //     months++;
  //     debugPrint('Total months: $months');
  //     debugPrint('Interest: $interest');
  //     debugPrint('endBalance: $endBalance');
  //     debugPrint('principle: $principle');
  //   }
  //   interest = endBalance * monthlyInterestRate;
  //   principle = endBalance;
  //   endBalance = 0.00;
  //   months++;
  //   debugPrint('Total months after : $months');
  //   debugPrint('Total principle: $principle');
  //   return months;
  // }
}

class _TableDataSource extends DataTableSource {
  _TableDataSource(this._tableData);

  final List<Map<String, dynamic>> _tableData;

  @override
  DataRow? getRow(int index) {
    if (index >= _tableData.length) {
      return null;
    }

    final rowData = _tableData[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text('${rowData['month']}')),
        DataCell(Text('${rowData['interest']}')),
        DataCell(Text('${rowData['principle']}')),
        DataCell(Text('${rowData['endBalance']}')),
      ],
    );
  }

  @override
  int get rowCount => _tableData.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
