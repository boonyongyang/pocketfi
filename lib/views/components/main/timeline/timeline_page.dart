import 'package:flutter/material.dart';
import 'package:pocketfi/views/components/animations/empty_contents_with_text_animation_view.dart';

@immutable
class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    // var height = AppBar().preferredSize.height;
    // print(height);
    return SafeArea(
      top: false,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black54,
            title: const Center(
              child: Text('Categories', style: TextStyle(color: Colors.white)),
            ),
            bottom: const TabBar(
              labelColor: Colors.blueGrey,
              unselectedLabelColor: Colors.white,
              indicatorColor: Colors.blueGrey,
              tabs: [
                Tab(
                  text: 'EXPENSES',
                ),
                Tab(
                  text: 'INCOME',
                ),
              ],
              labelStyle: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          // body: WalletAndTransactions(),
          body: const TabBarView(
            // physics: NeverScrollableScrollPhysics(),
            children: [
              EmptyContentsWithTextAnimationView(text: 'Expense'),
              EmptyContentsWithTextAnimationView(text: 'Income'),
              // _buildContents(context),
              // _buildContents(context),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => {},
            // onPressed: () => EditCategoryPage.show(context),
          ),
        ),
      ),
    );
  }
}
