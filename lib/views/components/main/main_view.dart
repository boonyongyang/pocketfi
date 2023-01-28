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

class _MainViewState extends ConsumerState<MainView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            Strings.appName,
          ),
          // actions: [],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.wallet),
              ),
              Tab(
                icon: Icon(Icons.find_replace_outlined),
              ),
              Tab(
                icon: Icon(Icons.receipt_long),
              ),
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
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {},
        ),
      ),
    );
  }
}
