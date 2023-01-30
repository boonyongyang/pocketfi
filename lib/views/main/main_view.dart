import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/auth/providers/auth_state_provider.dart';
// import 'package:pocketfi/state/image_upload/helpers/image_picker_helper.dart';
import 'package:pocketfi/state/image_upload/models/file_type.dart';
// import 'package:pocketfi/state/post_settings/providers/post_setting_provider.dart';
import 'package:pocketfi/views/components/dialogs/alert_dialog_model.dart';
import 'package:pocketfi/views/components/dialogs/logout_dialog.dart';
import 'package:pocketfi/views/constants/strings.dart';
// import 'package:pocketfi/views/create_new_posts/create_new_post_view.dart';
import 'package:pocketfi/views/tabs/users_posts_view.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

var indexProvider = StateProvider<int>((ref) => 0);

class _MainViewState extends ConsumerState<MainView>
    with AutomaticKeepAliveClientMixin<MainView> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            Strings.appName,
          ),
          // actions: [],
          bottom: const TabBar(
            indicatorColor: Colors.black,
            tabs: [
              Tab(icon: FaIcon(FontAwesomeIcons.moneyBills)),
              Tab(icon: FaIcon(FontAwesomeIcons.sackDollar)),
              Tab(icon: FaIcon(FontAwesomeIcons.personFallingBurst)),
              // icon: Icon(Icons.receipt_long)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // UserPostsView(),
            // UserPostsView(),
            // UserPostsView(),
            Center(
              child: Text(
                'Expenses',
              ),
            ),
            Center(
              child: Text(
                'Income',
              ),
            ),
            Center(
              child: Text(
                'Bills',
              ),
            ),
          ],
        ),
        // body: IndexedStack(
        //   index: ref.watch(indexProvider),
        //   children: [
        //     Text('Timeline'),
        //     Text('Timeline'),
        //     Text('Timeline'),
        //   ],
        // ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {},
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //     onTap: (index) {
        //       ref.read(indexProvider.notifier).state = index;
        //     },
        //     currentIndex: ref.watch(indexProvider),
        //     items: const [
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.timeline),
        //         label: 'Timeline',
        //       ),
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.attach_money),
        //         label: 'Budget',
        //       ),
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.local_florist_rounded),
        //         label: 'Finances',
        //       ),
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.person),
        //         label: 'Account',
        //       ),
        //     ]),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
