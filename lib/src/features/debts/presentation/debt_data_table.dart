import 'package:flutter/material.dart';
import 'package:pocketfi/src/features/debts/domain/debt.dart';

class DebtDataTable extends StatefulWidget {
  final Debt debt;

  const DebtDataTable({
    Key? key,
    required this.debt,
  }) : super(key: key);

  @override
  DebtDataTableState createState() => DebtDataTableState();
}

class DebtDataTableState extends State<DebtDataTable> {
  late List<Map<String, dynamic>> tableData;

  @override
  void initState() {
    super.initState();
    tableData = widget.debt.debtLoanInTable();
  }

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
