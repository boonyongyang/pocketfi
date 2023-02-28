import 'package:flutter/material.dart';
import 'package:pocketfi/src/features/timeline/posts/domain/post.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/transaction_card_test.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/transaction_card.dart';

class TransactionListViewTest extends StatelessWidget {
  final Iterable<Transaction> transactions;

  const TransactionListViewTest({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE1DCDC),
      constraints: const BoxConstraints(
          // minWidth: 100.0,
          // maxWidth: 320.0,
          // minHeight: 100.0,
          // maxHeight: 600.0,
          ),
      child: ListView.builder(
        // shrinkWrap: true,
        padding: const EdgeInsets.all(8.0),
        // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //   crossAxisCount: 1, // number of columns
        //   mainAxisSpacing: 8.0, // vertical spacing
        //   crossAxisSpacing: 8.0, // horizontal spacing
        // ),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction =
              transactions.elementAt(index); // get the post at the index
          return TransactionCardTest(
            transaction: transaction,
            transactionType: transaction.type,
            onTapped: () {
              // navigate to the post details view

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => PostDetailsView(
              //       post: post,
              //     ),
              //   ),
              // );

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => PostCommentsView(
              //       postId: post.postId,
              //     ),
              //   ),
              // );
            },
          );
        },
      ),
    );
  }
}
