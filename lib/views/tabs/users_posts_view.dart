import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/posts/providers/user_posts_provider.dart';
import 'package:pocketfi/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/views/components/animations/error_animation_view.dart';
import 'package:pocketfi/views/components/animations/loading_animation_view.dart';
import 'package:pocketfi/views/components/post/posts_grid_view.dart';
import 'package:pocketfi/views/constants/strings.dart';

class UserPostsView extends ConsumerWidget {
  const UserPostsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // get the posts from the provider
    // stream provider will automatically update the UI when the data changes
    final posts = ref.watch(userPostsProvider);

    // return a RefreshIndicator to allow the user to refresh the posts
    return RefreshIndicator(
      onRefresh: () {
        ref.refresh(userPostsProvider);
        return Future.delayed(
          const Duration(
            seconds: 1,
          ),
        );
      },
      // return a different widget depending on the state of the posts
      child: posts.when(
        // if the posts are loaded, return a list of posts
        data: (posts) {
          if (posts.isEmpty) {
            // if there are no posts, return an empty widget
            return const EmptyContentsWithTextAnimationView(
              text: Strings.youHaveNoPosts,
            );
          } else {
            // if there are posts, return a list of posts
            return PostsGridView(
              posts: posts,
            );
          }
        },

        // if there is an error, return an error widget
        error: (error, stackTrace) {
          return const ErrorAnimationView();
        },

        // if the posts are loading, return a loading widget
        loading: () {
          return const LoadingAnimationView();
        },
      ),
    );
  }
}
