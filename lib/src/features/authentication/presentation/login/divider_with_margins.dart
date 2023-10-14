import 'package:flutter/material.dart';

class DividerWithMargins extends StatelessWidget {
  const DividerWithMargins({super.key});

  @override
  Widget build(BuildContext context) {
    // return const Padding(
    //   padding: EdgeInsets.symmetric(horizontal: 40.0),
    //   child: Divider(),
    // );
    return const Column(
      children: [SizedBox(height: 20), Divider(), SizedBox(height: 20)],
    );
  }
}
