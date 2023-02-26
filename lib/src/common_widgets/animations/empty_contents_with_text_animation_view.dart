import 'package:flutter/material.dart';

import 'empty_contents_animation_view.dart';

class EmptyContentsWithTextAnimationView extends StatelessWidget {
  final String text;

  const EmptyContentsWithTextAnimationView({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ),
          const EmptyContentsAnimationView(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
