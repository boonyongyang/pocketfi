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

    return GestureDetector(
      onTap: onTapped,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: category.color),
                      child: Center(child: category.icon),
                    ),
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(bill.categoryName),
                          Text(
                            bill.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(bill.walletName),
                          Text(DateFormat('dd/MM/yyyy').format(bill.dueDate)),
                          Text(bill.status.name,
                              style: TextStyle(
                                color: bill.status.color,
                                fontSize: 12,
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(bill.amount.toStringAsFixed(2)),
                  ],
                ),
                Text(bill.status.name,
                    style: TextStyle(
                      color: bill.status.color,
                      fontSize: 12,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
// if the bill is less than a week away, show the bill in red
// if the bill is less than a month away, show the bill in orange
// if bill is paid, show the bill strikethrough
// if bill is unpaid, show the bill normally
}
