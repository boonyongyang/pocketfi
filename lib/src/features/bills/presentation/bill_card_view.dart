import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketfi/src/features/category/application/category_services.dart';
import 'package:pocketfi/src/features/bills/domain/bill.dart';

class BillCard extends ConsumerWidget {
  final Bill bill;
  final VoidCallback onTapped;
  const BillCard({
    Key? key,
    required this.bill,
    required this.onTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = getCategoryWithCategoryName(bill.categoryName);

    final differenceInDays = bill.dueDate.difference(DateTime.now()).inDays;

    final textColor = differenceInDays < 3
        ? Colors.red
        : differenceInDays < 30
            ? Colors.orange
            : Colors.black;

    final amountColor =
        bill.status == BillStatus.overdue ? Colors.red : Colors.black;

    final now = DateTime.now();
    final dueDate = bill.dueDate;

    String status;

    if (dueDate.year < now.year ||
        (dueDate.year == now.year && dueDate.month < now.month) ||
        (dueDate.year == now.year &&
            dueDate.month == now.month &&
            dueDate.day < now.day)) {
      final differenceInDays = now.difference(dueDate).inDays;
      status = 'Overdue by $differenceInDays day(s)';
    } else if (dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day) {
      status = 'Due Today';
    } else if (dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day + 1) {
      status = 'Due Tomorrow';
    } else {
      final differenceInDays = dueDate.difference(now).inDays;
      status = 'Due in $differenceInDays day(s)';
    }

    final textDecoration = bill.status == BillStatus.paid
        ? TextDecoration.lineThrough
        : TextDecoration.none;

    return GestureDetector(
      onTap: onTapped,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: category.color,
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: category.icon),
                  ),
                  const SizedBox(height: 32.0),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Text(
                'MYR ${bill.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: amountColor,
                ),
              ),
            ),
            Visibility(
              visible: bill.status != BillStatus.paid,
              child: Positioned(
                bottom: -6,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: textColor,
                      decoration: textDecoration,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 70,
              bottom: 0,
              right: 130,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    bill.categoryName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Visibility(
                    visible: bill.description.isNotEmpty,
                    child: Text(
                      bill.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Text(bill.walletName),
                  Text(
                    DateFormat('dd/MM/yyyy').format(bill.dueDate),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
