import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketfi/src/common_widgets/dialogs/action_sheet.dart';
import 'package:pocketfi/src/common_widgets/dialogs/alert_dialog_model.dart';
import 'package:pocketfi/src/common_widgets/dialogs/selection_dialog.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/shared/image_upload/data/image_file_notifier.dart';
import 'package:pocketfi/src/features/timeline/bookmarks/presentation/bookmark_page.dart';
import 'package:pocketfi/src/features/timeline/posts/post_settings/application/post_setting_provider.dart';
import 'package:pocketfi/src/features/timeline/presentation/overview_tab.dart';
import 'package:pocketfi/src/features/timeline/transactions/data/transaction_notifiers.dart';
import 'package:pocketfi/src/features/shared/image_upload/domain/file_type.dart';
import 'package:pocketfi/src/features/shared/image_upload/helpers/image_picker_helper.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/add_new_transactions/add_new_transaction.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/add_new_transactions/create_new_post_view.dart';
import 'package:pocketfi/src/features/timeline/receipts/add_transaction_with_receipt.dart';
import 'package:pocketfi/src/features/timeline/receipts/scan_receipt.dart';
import 'package:pocketfi/src/features/timeline/presentation/transactions_tab.dart';
import 'package:pocketfi/src/features/timeline/presentation/post_tab.dart';
import 'package:pocketfi/src/features/timeline/receipts/verify_receipt_details.dart';

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
          bottom: TabBar(
            indicatorColor: AppColors.mainColor2,
            labelColor: AppColors.mainColor2,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  // FaIcon(FontAwesomeIcons.moneyBills),
                  Text('Lists'),
                ],
              )),
              Tab(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  // FaIcon(FontAwesomeIcons.chartPie),
                  Text('Overview'),
                ],
              )),
              Tab(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  // Icon(Icons.receipt_long),
                  Text('Bills'),
                ],
              )),
              // Tab(icon: FaIcon(FontAwesomeIcons.moneyBills)),
              // Tab(icon: FaIcon(FontAwesomeIcons.chartPie)),
              // Tab(icon: Icon(Icons.receipt_long)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TransactionsTab(),
            OverviewTab(),
            // TempTab(),
            PostsTab(),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: null,
              backgroundColor: const Color(0xFFFCD46A),
              child: const Icon(Icons.camera_alt),

              // * implementing receipt scanning feature
              onPressed: () async {
                final XFile? pickedImage;

                final isCamera = await const SelectionDialog(
                  title: Strings.scanReceiptFrom,
                ).present(context);

                if (isCamera == null) return;

                pickedImage = isCamera
                    ? await ImagePicker().pickImage(
                        source: ImageSource.camera,
                      )
                    : await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );

                if (pickedImage != null) {
                  if (mounted) {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) {
                          // ref
                          //     .read(receiptFileProvider.notifier)
                          //     .setReceiptImageFile(pickedImage);
                          return VerifyReceiptDetails(pickedImage: pickedImage);
                        },
                        fullscreenDialog: true,
                      ),
                    );
                  }
                }
              },

              // * implement hightlight text feature
              // onPressed: () async {

              // * ori code
              // onPressed: () => Navigator.of(context, rootNavigator: true).push(
              //   MaterialPageRoute(
              //     builder: (context) => const ScanReceipt(),
              //   ),
              // ),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              heroTag: null,
              backgroundColor: AppColors.subColor2,
              child: const Icon(Icons.receipt),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => const ScanReceipt(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              // heroTag: 'bookmarks',
              heroTag: null,
              backgroundColor: AppColors.subColor2,
              child: const Icon(Icons.bookmarks),
              onPressed: () {
                // Beamer.of(context).beamToNamed('/timeline/overview'),
                setNewTransactionState(ref);
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => const BookmarkPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
                // heroTag: 'add_new_expense',
                heroTag: null,
                backgroundColor: const Color(0xFFFCD46A),
                child: const Icon(Icons.add),
                onPressed: () {
                  setNewTransactionState(ref);
                  Navigator.of(context, rootNavigator: true).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const AddNewTransaction(),
                      transitionDuration: const Duration(milliseconds: 200),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        final curvedAnimation = CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeIn,
                          reverseCurve: Curves.easeIn,
                        );
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 1),
                            end: Offset.zero,
                          ).animate(curvedAnimation),
                          child: child,
                        );
                      },
                      // transitionsBuilder:
                      //     (context, animation, secondaryAnimation, child) {
                      //   return SlideTransition(
                      //     position: Tween<Offset>(
                      //       begin: const Offset(0, 1),
                      //       end: Offset.zero,
                      //     ).animate(animation),
                      //     child: child,
                      //   );
                      // },
                    ),
                  );
                }),
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
