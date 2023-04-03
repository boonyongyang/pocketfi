import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/bills/application/bill_services.dart';
import 'package:pocketfi/src/features/bills/domain/bill.dart';
import 'package:pocketfi/src/features/bills/presentation/update_bill_page.dart';
import 'package:pocketfi/src/features/category/application/category_services.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';

class BillDetailSheet extends ConsumerWidget {
  const BillDetailSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBill = ref.watch(selectedBillProvider)!;
    final category = getCategoryWithCategoryName(selectedBill.categoryName);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Container(
        color: AppColors.transparent,
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          runSpacing: 20,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                    ),
                    const Spacer(),
                    CircleAvatar(
                      backgroundColor: category.color,
                      child: category.icon,
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      selectedBill.categoryName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => const UpdateBillPage(),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Text(
                        "MYR ${selectedBill.amount.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: TransactionType.expense.color,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "Due Date: ${DateFormat('dd/MM/yyyy').format(selectedBill.dueDate)}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Description: ${selectedBill.description}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Wallet: ${selectedBill.walletName}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Status: ${selectedBill.status.name}",
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedBill.status.color,
                  ),
                ),
              ],
            ),
            FullWidthButtonWithText(
              onPressed: () {
                Fluttertoast.showToast(
                  msg: "Bill marked as paid.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.white,
                  textColor: AppColors.mainColor1,
                  fontSize: 16.0,
                );
                ref.read(selectedBillProvider.notifier).updateBillStatus(
                      BillStatus.paid,
                      ref,
                    );
                Navigator.of(context).pop();
              },
              text: "Mark as Paid",
              backgroundColor: AppColors.mainColor2,
            ),
          ],
        ),
      ),
    );
  }
}
