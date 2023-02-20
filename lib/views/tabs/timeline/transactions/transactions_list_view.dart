import 'package:flutter/material.dart';
import 'package:pocketfi/state/tabs/timeline/posts/models/post.dart';
import 'package:pocketfi/state/tabs/timeline/transaction/models/transaction_type.dart';
import 'package:pocketfi/views/tabs/timeline/transactions/transaction_card.dart';
// import 'package:pocketfi/views/post_comments/post_comments_view.dart';

class TransactionsListView extends StatelessWidget {
  final Iterable<Post> posts;

  const TransactionsListView({
    Key? key,
    required this.posts,
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
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts.elementAt(index); // get the post at the index
          return TransactionCard(
            post: post,
            transactionType: TransactionType.expense,
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
