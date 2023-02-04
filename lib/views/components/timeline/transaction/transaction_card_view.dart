import 'package:flutter/material.dart';
import 'package:pocketfi/state/timeline/transaction/models/transaction.dart';
import 'package:pocketfi/views/components/animations/small_error_animation_view.dart';

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
          Image.network(
            transaction.thumbnailUrl,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
