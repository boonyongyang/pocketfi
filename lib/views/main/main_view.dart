import 'package:beamer/beamer.dart';
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
          backgroundColor: const Color(0xFF0F3D66),
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
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
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
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
        body: const TabBarView(
          children: [
            UserPostsView(),
            UserPostsView(),
            UserPostsView(),
            // Center(
            //   child: Text(
            //     'Expenses',
            //   ),
            // ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFFFCD46A),
          child: const Icon(Icons.add),
          onPressed: () => Beamer.of(context).beamToNamed('/timeline/details'),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
