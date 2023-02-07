import 'package:flutter/material.dart';
import 'package:pocketfi/state/timeline/transaction/create_new_transaction/transaction_type.dart';

class MyTransaction extends StatelessWidget {
  final String? description;
  final String money;
  final TransactionType expenseOrIncome;

  const MyTransaction({
    super.key,
    required this.description,
    required this.money,
    required this.expenseOrIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      const Text('Food and Drink',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF51779E),
                          )),
                      Text(description ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          )),
                    ],
                  ),
                ],
              ),
              Text(
                '${expenseOrIncome == TransactionType.expense ? '-' : '+'}\$$money',
                style: TextStyle(
                  //fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: expenseOrIncome == TransactionType.expense
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
