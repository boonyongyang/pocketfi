import 'package:flutter/material.dart';
import 'package:pocketfi/state/tabs/timeline/posts/models/post.dart';
import 'package:pocketfi/state/tabs/timeline/transaction/models/transaction_type.dart';
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
          MyTransaction(
            description: post.message,
            money: post.amount.toString(),
            transactionType: TransactionType.expense,
            post: post,
          ),
          // Image.network(
          //   post.thumbnailUrl,
          //   fit: BoxFit.cover,
          //   height: 100.0,
          // ),
        ],
      ),
    );
  }
}
