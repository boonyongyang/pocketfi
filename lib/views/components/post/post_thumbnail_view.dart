import 'package:flutter/material.dart';
import 'package:pocketfi/state/posts/models/post.dart';
import 'package:pocketfi/state/timeline/transaction/create_new_transaction/transaction_type.dart';
import 'package:pocketfi/views/components/timeline/transaction/my_transaction.dart';

class PostThumbnailView extends StatelessWidget {
  final Post post;
  final VoidCallback onTapped;
  const PostThumbnailView({
    Key? key,
    required this.post,
    required this.onTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapped,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MyTransaction(
            description: 'Chicken Rice',
            money: '8.00',
            expenseOrIncome: TransactionType.expense,
          ),
          Image.network(
            post.thumbnailUrl,
            fit: BoxFit.cover,
            height: 100.0,
          ),
        ],
      ),
    );
  }
}
