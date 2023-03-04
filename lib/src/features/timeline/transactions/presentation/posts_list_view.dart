import 'package:flutter/material.dart';
import 'package:pocketfi/src/features/timeline/posts/domain/post.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/post_card_view.dart';

class PostsListView extends StatelessWidget {
  final Iterable<Post> posts;

  const PostsListView({
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
          return PostCardView(
            post: post,
            transactionType: TransactionType.expense,
            onTapped: () {
              // * navigate to the post details view

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
