import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/lottie_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/models/lottie_animation.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/timeline/posts/post_settings/application/post_setting_provider.dart';
import 'package:pocketfi/src/features/timeline/transactions/image_upload/domain/file_type.dart';
import 'package:pocketfi/src/features/timeline/transactions/image_upload/helpers/image_picker_helper.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/add_new_transactions/add_new_transaction.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/add_new_transactions/create_new_post_view.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/receipts/scan_receipt.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/transactions_tab.dart';

class TimelinePage extends ConsumerStatefulWidget {
  const TimelinePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<TimelinePage>
    with AutomaticKeepAliveClientMixin<TimelinePage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor1,
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications,
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

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => CreateNewPostView(
                    //       fileToPost: videoFile,
                    //       fileType: FileType.video,
                    //     ),
                    //   ),
                    // );
                    context.beamToNamed('/timeline/transactions');
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
                  onPressed: () => pickImage(),
                ),
              ],
            ),
          ),
          // actions: [],
          bottom: const TabBar(
            indicatorColor: AppColors.mainColor2,
            labelColor: AppColors.mainColor2,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: FaIcon(FontAwesomeIcons.moneyBills)),
              Tab(icon: FaIcon(FontAwesomeIcons.chartPie)),
              // Tab(icon: FaIcon(FontAwesomeIcons.receipt)),
              Tab(icon: Icon(Icons.receipt_long)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const TransactionsTab(),
            const Center(
              child: Text('Charts'),
            ),
            Center(
              child: Column(
                children: const [
                  Text('Bills'),
                  LottieAnimationView(animation: LottieAnimation.welcomeApp),
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
              // heroTag: 'scan_receipt',
              heroTag: null,
              backgroundColor: const Color(0xFFFCD46A),
              child: const Icon(Icons.camera_alt),
              onPressed: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => const ScanReceipt(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              // heroTag: 'bookmarks',
              heroTag: null,
              backgroundColor: AppColors.subColor2,
              child: const Icon(Icons.bookmarks),
              onPressed: () =>
                  Beamer.of(context).beamToNamed('/timeline/overview'),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              // heroTag: 'add_new_expense',
              heroTag: null,
              backgroundColor: const Color(0xFFFCD46A),
              child: const Icon(Icons.add),
              onPressed: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => const AddNewTransaction(),
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

  pickImage() async {
    // pick a image first
    final imageFile = await ImagePickerHelper.pickImageFromGallery();
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
  }

  createTransactionTest() async {
    // pick a image first
    final imageFile = await ImagePickerHelper.pickImageFromGallery();
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
  }
}
