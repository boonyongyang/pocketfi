import 'package:flutter/material.dart';
import 'package:pocketfi/state/tabs/timeline/transaction/models/transaction_type.dart';
import 'package:pocketfi/state/tabs/timeline/transaction/models/transaction.dart';

class TransactionCardView extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTapped;

  const TransactionCardView({
    Key? key,
    required this.transaction,
    required this.onTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapped,
      child: Column(
        children: [
          const Text('ExpenseCardView'),
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(15),
                color: Colors.grey[100],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey[500]),
                          child: const Center(
                            child: Icon(
                              Icons.attach_money_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            Text(transaction.category,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF51779E),
                                )),
                            Text(transaction.description ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                )),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '${transaction.type == TransactionType.expense ? '-' : '+'}\$$transaction.amount',
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: transaction.type == TransactionType.expense
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Image.network(
            transaction.thumbnailUrl ?? '',
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
