import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart';
import 'package:pocketfi/state/auth/providers/auth_state_provider.dart';
// import 'package:pocketfi/state/image_upload/helpers/image_picker_helper.dart';
import 'package:pocketfi/state/image_upload/models/file_type.dart';
// import 'package:pocketfi/state/post_settings/providers/post_setting_provider.dart';
import 'package:pocketfi/views/components/dialogs/alert_dialog_model.dart';
import 'package:pocketfi/views/components/dialogs/logout_dialog.dart';
import 'package:pocketfi/views/components/main/main_view.dart';
import 'package:pocketfi/views/constants/strings.dart';
// import 'package:pocketfi/views/create_new_posts/create_new_post_view.dart';
import 'package:pocketfi/views/tabs/users_posts_view.dart';

// var indexProvider = StateProvider<int>((ref) => 0);

class BottomNavBarView extends ConsumerWidget {
  const BottomNavBarView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            // title: const Text(
            //   Strings.appName,
            // ),
            ),
        body: IndexedStack(
          index: ref.watch(indexProvider),
          children: const [
            // MainView(),
            UserPostsView(),
            UserPostsView(),
            Text('Timeline'),
            Text('Budget'),
            // Text('Finances'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {},
        ),
        bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.green,
            selectedItemColor: Colors.red,
            backgroundColor: Colors.black,
            onTap: (index) {
              ref.read(indexProvider.notifier).state = index;
            },
            currentIndex: ref.watch(indexProvider),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.timeline),
                label: 'Timeline',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.attach_money),
                label: 'Budget',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_florist_rounded),
                label: 'Finances',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Account',
              ),
            ]),
      ),
    );
  }
}
