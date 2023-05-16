import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/debts/data/debt_payment_repository.dart';
import 'package:pocketfi/src/features/debts/domain/debt.dart';
import 'package:pocketfi/src/features/debts/presentation/debt_payment_sheet.dart';

class UpcomingDebtView extends ConsumerWidget {
  final Debt debt;
  const UpcomingDebtView({super.key, required this.debt});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Map<String, dynamic>> tableData = debt.debtLoanInTable();
    final debtHistories = ref.watch(userDebtPaymentsProvider).value;
    if (debtHistories == null) {
      return Container();
    }
    for (var history in debtHistories) {
      if (history.debtId == debt.debtId) {
        tableData
            .removeWhere((element) => element['month'] == history.paidMonth);
      }
    }

    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: tableData.length,
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> rowData = tableData[index];
            double totalPayment = double.parse(rowData['interest']) +
                double.parse(rowData['principle']);
            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => DebtPaymentSheet(
                    rowData: rowData,
                    previousRowData: index > 0 ? tableData[index - 1] : null,
                    debt: debt,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.0),
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ListTile(
                    title: Text(rowData['month'],
                        style: const TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: AppColors.mainColor1,
                        )),
                    subtitle: Text(
                      'MYR ${totalPayment.toStringAsFixed(2)}',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
