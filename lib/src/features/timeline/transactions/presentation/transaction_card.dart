import 'package:flutter/material.dart';
import 'package:pocketfi/src/features/timeline/posts/domain/post.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';

class TransactionCard extends StatelessWidget {
  final Post post;
  final TransactionType transactionType;
  final VoidCallback onTapped;
  const TransactionCard({
    Key? key,
    required this.post,
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
                          Icons.restaurant,
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
                          const Text('Food and Drinks',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF51779E),
                              )),
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
                          Text(post.message,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              )),
                          // if thumbnailUrl is not null, show the image
                          // else show a SizedBox
                          if (post.thumbnailUrl != null)
                            Image.network(
                              post.thumbnailUrl ?? '',
                              fit: BoxFit.cover,
                              height: 100.0,
                            )
                          else
                            const SizedBox(),
                          // Image.network(
                          //   post.thumbnailUrl ?? '',
                          //   fit: BoxFit.cover,
                          //   height: 100.0,
                          // ),
                          Text(post.createdAt.toIso8601String()),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  '${transactionType == TransactionType.expense ? '-' : '+'}MYR ${post.amount}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
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
