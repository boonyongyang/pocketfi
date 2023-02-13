import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/tabs/timeline/posts/models/post.dart';
import 'package:pocketfi/state/tabs/timeline/transaction/models/transaction_type.dart';

class MyTransaction extends ConsumerWidget {
  final String? description;
  final String money;
  final TransactionType transactionType;
  final Post post;

  const MyTransaction({
    super.key,
    required this.description,
    required this.money,
    required this.transactionType,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
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
                              // avatar: CircleAvatar(
                              //   backgroundColor: Colors.grey.shade800,
                              //   child: const Text('A'),
                              // ),
                              label: const Text('Lunch'),
                              onPressed: () =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Lunch'),
                                ),
                              ),
                            ),
                            const Chip(
                              label: Text('Foodpanda'),
                            ),
                          ],
                        ),
                        Text(description ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            )),
                        Image.network(
                          post.thumbnailUrl ?? '',
                          fit: BoxFit.cover,
                          height: 100.0,
                        ),
                        Text(post.createdAt.toIso8601String()),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                '${transactionType == TransactionType.expense ? '-' : '+'}MYR $money',
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
    );
  }
}
