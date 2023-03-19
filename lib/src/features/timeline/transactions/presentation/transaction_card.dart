import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/category/application/category_providers.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTapped;
  const TransactionCard({
    Key? key,
    required this.transaction,
    required this.onTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final category = getCategoryWithCategoryName(transaction.categoryName);
    final transactionType = transaction.type;

    return GestureDetector(
      onTap: onTapped,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: ClipRRect(
          // borderRadius: BorderRadius.circular(10.0),
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
                    const SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.categoryName,
                          ),
                          const ShowTags(),
                          Text(transaction.description ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              )),
                          if (transaction.thumbnailUrl != null)
                            Image.network(
                              transaction.thumbnailUrl!,
                              height: 100,
                              // width: 100,
                              fit: BoxFit.cover,
                            )
                          else
                            const SizedBox(),
                          // Text(transaction.createdAt!.toIso8601String()),
                          Text(transaction.walletName),
                          // format date to dd/mm/yyyy
                          Text(DateFormat('d MMM').format(transaction.date)),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  '${transactionType == TransactionType.expense ? TransactionType.expense.symbol : transactionType == TransactionType.income ? TransactionType.income.symbol : TransactionType.transfer.symbol}MYR ${transaction.amount}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: transactionType == TransactionType.expense
                        ? TransactionType.expense.color
                        : transactionType == TransactionType.income
                            ? TransactionType.income.color
                            : TransactionType.transfer.color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShowTags extends StatelessWidget {
  const ShowTags({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ActionChip(
          visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0),
          // materialTapTargetSize:
          //     MaterialTapTargetSize.shrinkWrap,
          label: const Text('Lunch'),
          onPressed: () => Fluttertoast.showToast(
            msg: "Lunch!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.white,
            textColor: AppColors.mainColor1,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(width: 5),
        const Chip(
          visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
          label: Text('Foodpanda'),
        ),
      ],
    );
  }
}
