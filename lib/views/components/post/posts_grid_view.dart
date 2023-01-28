import 'package:flutter/material.dart';
import 'package:pocketfi/state/posts/models/post.dart';
import 'package:pocketfi/views/components/post/post_thumbnail_view.dart';
// import 'package:pocketfi/views/post_comments/post_comments_view.dart';

class PostsGridView extends StatelessWidget {
  final Iterable<Post> posts;

  const PostsGridView({
    Key? key,
    required this.posts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // number of columns
        mainAxisSpacing: 8.0, // vertical spacing
        crossAxisSpacing: 8.0, // horizontal spacing
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts.elementAt(index); // get the post at the index
        return PostThumbnailView(
          post: post,
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
    );
  }
}
