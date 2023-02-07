import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/auth/providers/auth_state_provider.dart';
import 'package:pocketfi/state/image_upload/helpers/image_picker_helper.dart';
// import 'package:pocketfi/state/image_upload/helpers/image_picker_helper.dart';
import 'package:pocketfi/state/image_upload/models/file_type.dart';
import 'package:pocketfi/state/post_settings/providers/post_setting_provider.dart';
import 'package:pocketfi/views/components/animations/loading_animation_view.dart';
// import 'package:pocketfi/state/post_settings/providers/post_setting_provider.dart';
import 'package:pocketfi/views/components/dialogs/alert_dialog_model.dart';
import 'package:pocketfi/views/components/dialogs/logout_dialog.dart';
import 'package:pocketfi/views/constants/strings.dart';
import 'package:pocketfi/views/create_new_posts/create_new_post_view.dart';
import 'package:pocketfi/views/main/account/account_page.dart';
import 'package:pocketfi/views/main/account/setting_page.dart';
// import 'package:pocketfi/views/create_new_posts/create_new_post_view.dart';
import 'package:pocketfi/views/tabs/users_posts_view.dart';

class TimelineView extends ConsumerStatefulWidget {
  const TimelineView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

var indexProvider = StateProvider<int>((ref) => 0);

class _MainViewState extends ConsumerState<TimelineView>
    with AutomaticKeepAliveClientMixin<TimelineView> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F3D66),
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    // pick a video first
                    final videoFile =
                        await ImagePickerHelper.pickVideoFromGallery();
                    if (videoFile == null) {
                      // no video available so return early
                      return;
                    }

                    // refresh the provider so it does not contain the previous post's setting
                    ref.refresh(postSettingProvider);

                    // go to the screen to create a new post
                    if (!mounted) {
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CreateNewPostView(
                          fileToPost: videoFile,
                          fileType: FileType.video,
                        ),
                      ),
                    );
                  },
                ),
                Center(
                  child: Column(
                    children: const [
                      Text(
                        // Strings.appName,
                        '- MYR 3,250.50',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Cash Flow',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    // pick a image first
                    final imageFile =
                        await ImagePickerHelper.pickImageFromGallery();
                    if (imageFile == null) {
                      // no image available so return early
                      return;
                    }

                    // refresh the provider so it does not contain the previous post's setting
                    ref.refresh(postSettingProvider);

                    // go to the screen to create a new post
                    if (!mounted) {
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CreateNewPostView(
                          fileToPost: imageFile,
                          fileType: FileType.image,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // actions: [],
          bottom: const TabBar(
            indicatorColor: Color(0xFFF8B319),
            labelColor: Color(0xFFF8B319),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: FaIcon(FontAwesomeIcons.moneyBills)),
              Tab(icon: FaIcon(FontAwesomeIcons.sackDollar)),
              Tab(icon: FaIcon(FontAwesomeIcons.personFallingBurst)),
              // icon: Icon(Icons.receipt_long)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const UserPostsView(),
            const UserPostsView(),
            // UserPostsView(),
            Center(
              child: Column(
                children: const [
                  Text('Bills'),
                  LoadingAnimationView(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: Container()),
            FloatingActionButton(
              heroTag: 'bookmark',
              backgroundColor: const Color(0xFFFCD46A),
              child: const Icon(Icons.bookmarks),
              onPressed: () =>
                  Beamer.of(context).beamToNamed('/timeline/details'),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              heroTag: 'scan receipt',
              backgroundColor: const Color(0xFFFCD46A),
              child: const Icon(Icons.camera_alt),
              onPressed: () =>
                  // Beamer.of(context).beamToNamed('/timeline/details'),
                  ScaffoldMessenger.of(context).showSnackBar(
                // SnackBar(content: Text('Value is ${current.state}')),
                SnackBar(content: Text('Value is $ref')),
              ),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              heroTag: 'add new expense',
              backgroundColor: const Color(0xFFFCD46A),
              child: const Icon(Icons.add),
              onPressed: () =>
                  // Beamer.of(context).beamToNamed('/timeline/details'),
                  Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                  fullscreenDialog: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
