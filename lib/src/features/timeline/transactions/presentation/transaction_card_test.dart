import 'package:flutter/material.dart';
import 'package:pocketfi/src/features/timeline/posts/domain/post.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';

class TransactionCardTest extends StatelessWidget {
  final Transaction transaction;
  final TransactionType transactionType;
  final VoidCallback onTapped;
  const TransactionCardTest({
    Key? key,
    required this.transaction,
    required this.onTapped,
    required this.transactionType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapped,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
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
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.amber),
                      child: const Center(
                        child: Icon(
                          Icons.attach_money,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // category
                          // const Text('Food and Drinks',
                          //     style: TextStyle(
                          //       fontSize: 16,
                          //       color: Color(0xFF51779E),
                          //     )),
                          Text(
                            transaction.category,
                          ),
                          Row(
                            children: [
                              // list of ActionChip with different tags
                              // const ActionChip(
                              //   label: Text('Food'),
                              //   onPressed: null,
                              // ),
                              // const SizedBox(
                              //   width: 5,
                              // ),
                              // const ActionChip(
                              //   label: Text('Parking'),
                              //   onPressed: null,
                              // ),
                              // const SizedBox(
                              //   width: 5,
                              // ),
                              // const ActionChip(
                              //   label: Text('Dinner'),
                              //   onPressed: null,
                              // ),
                              ActionChip(
                                visualDensity: const VisualDensity(
                                    horizontal: -4.0, vertical: -4.0),
                                // materialTapTargetSize:
                                //     MaterialTapTargetSize.shrinkWrap,
                                label: const Text('Lunch'),
                                onPressed: () =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Lunch!'),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Chip(
                                visualDensity: VisualDensity(
                                    horizontal: -4.0, vertical: -4.0),
                                label: Text('Foodpanda'),
                              ),
                            ],
                          ),
                          Text(transaction.description ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              )),
                          // if transaction has a thumbnail, show it else
                          // show a placeholder
                          if (transaction.thumbnailUrl != null)
                            Image.network(
                              transaction.thumbnailUrl!,
                              height: 100,
                              // width: 100,
                              fit: BoxFit.cover,
                            )
                          else
                            const SizedBox(),
                          // Image.network(
                          //   transaction.thumbnailUrl ?? '',
                          //   fit: BoxFit.cover,
                          //   height: 100.0,
                          // ),
                          Text(transaction.createdAt.toIso8601String()),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  '${transactionType == TransactionType.expense ? '-' : '+'}MYR ${transaction.amount}',
                  style: TextStyle(
                    //fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: transactionType == TransactionType.expense
                        ? Colors.red
                        : Colors.green,
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
