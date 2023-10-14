import 'dart:io';
import 'dart:typed_data';

import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/overview/application/overview_services.dart';
import 'package:pocketfi/src/features/shared/image_upload/data/image_file_notifier.dart';
import 'package:pocketfi/src/features/bookmarks/presentation/bookmark_page.dart';
import 'package:pocketfi/src/features/overview/presentation/overview_tab_view.dart';
import 'package:pocketfi/src/features/receipts/scan_receipt_page.dart';
import 'package:pocketfi/src/features/transactions/application/transaction_services.dart';
import 'package:pocketfi/src/features/transactions/presentation/add_new_transactions/add_new_transaction.dart';
import 'package:pocketfi/src/features/transactions/presentation/transactions_tab_view.dart';

class TimelinePage extends ConsumerStatefulWidget {
  const TimelinePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<TimelinePage>
    with AutomaticKeepAliveClientMixin<TimelinePage> {
  // double getTotalAmount() {
  //   final transactions = ref.watch(userTransactionsProvider).value;
  //   double total = 0.0;
  //   if (transactions != null) {
  //     for (Transaction transaction in transactions) {
  //       if (transaction.type == TransactionType.expense) {
  //         total -= transaction.amount;
  //       } else if (transaction.type == TransactionType.income) {
  //         total += transaction.amount;
  //       }
  //     }
  //   }
  //   return total;
  // }

  String getNetAmountString() {
    // double netAmount = 5000;
    double netAmount = ref.watch(totalAmountProvider);
    String sign = netAmount < 0 ? '-' : '';
    String formattedAmount = NumberFormat.currency(
      symbol: 'MYR ',
      decimalDigits: 2,
    ).format(netAmount.abs());
    return '$sign$formattedAmount';
  }

  @override
  Widget build(BuildContext context) {
    String netAmount = getNetAmountString();
    super.build(context);
    return DefaultTabController(
      length: 2,
      // length: 3,
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
                  onPressed: () {},
                ),
                // IconButton(
                //   icon: const Icon(
                //     Icons.videocam,
                //     color: Colors.white,
                //   ),
                //   onPressed: () async {
                //     // pick a video first
                //     final videoFile =
                //         await ImagePickerHelper.pickVideoFromGallery();
                //     if (videoFile == null) {
                //       // no video available so return early
                //       return;
                //     }

                //     // refresh the provider so it does not contain the previous
                //     ref.refresh(userTransactionsProvider);

                //     // go to the screen to create a new post
                //     if (!mounted) return;

                //     // Navigator.push(
                //     //   context,
                //     //   MaterialPageRoute(
                //     //     builder: (_) => CreateNewPostView(
                //     //       fileToPost: videoFile,
                //     //       fileType: FileType.video,
                //     //     ),
                //     //   ),
                //     // );
                //     context.beamToNamed('/transactions');
                //   },
                // ),
                Center(
                  child: Column(
                    children: [
                      Text(
                        // '- MYR 3,250.50',
                        netAmount,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const Padding(
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
                // IconButton(
                //   icon: const Icon(
                //     Icons.camera,
                //     color: Colors.white,
                //   ),
                //   onPressed: () {
                //     Navigator.of(context, rootNavigator: true).push(
                //       MaterialPageRoute(
                //         builder: (context) => const ScanReceipt(),
                //       ),
                //     );
                //   },
                // ),
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Fluttertoast.showToast(
                      msg: 'Search for what?',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 16.0,
                    );
                  },
                ),
              ],
            ),
          ),
          bottom: const TabBar(
            indicatorColor: AppColors.mainColor2,
            labelColor: AppColors.mainColor2,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // FaIcon(FontAwesomeIcons.moneyBills),
                  Text('Transactions'),
                ],
              )),
              Tab(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // FaIcon(FontAwesomeIcons.chartPie),
                  Text('Overview'),
                ],
              )),
              // Tab(
              //     child: Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: const [
              //     // Icon(Icons.receipt_long),
              //     Text('Bills'),
              //   ],
              // )),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TransactionsTabView(),
            OverviewTabView(),
            // BillsTabView(),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // FloatingActionButton(
            //   heroTag: null,
            //   backgroundColor: const Color(0xFFFCD46A),
            //   child: const Icon(Icons.kayaking),
            //   onPressed: () async {
            //     // * implement `hightlight` text feature
            //     Navigator.of(context, rootNavigator: true).push(
            //       MaterialPageRoute(
            //         builder: (context) {
            //           return const ScanningTest();
            //         },
            //         fullscreenDialog: true,
            //       ),
            //     );
            //   },
            // ),
            // const SizedBox(height: 16),
            FloatingActionButton(
              heroTag: null,
              backgroundColor: const Color(0xFFFCD46A),
              child: const Icon(Icons.camera_alt),

              // * implement edge detection scanning
              onPressed: () async {
                await getImage();

                if (ref.read(receiptStringPathProvider) != null) {
                  if (mounted) {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const ScanReceiptPage();
                        },
                        fullscreenDialog: true,
                      ),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 16),
            // FloatingActionButton(
            //   heroTag: null,
            //   backgroundColor: AppColors.subColor2,
            //   child: const Icon(Icons.receipt),
            //   onPressed: () async {
            //     // * implementing receipt scanning
            //     final XFile? pickedImage;

            //     final isCamera = await const SelectionDialog(
            //       title: Strings.scanReceiptFrom,
            //     ).present(context);

            //     if (isCamera == null) return;

            //     pickedImage = isCamera
            //         ? await ImagePicker().pickImage(
            //             source: ImageSource.camera,
            //           )
            //         : await ImagePicker().pickImage(
            //             source: ImageSource.gallery,
            //           );

            //     if (pickedImage != null) {
            //       if (mounted) {
            //         Navigator.of(context, rootNavigator: true).push(
            //           MaterialPageRoute(
            //             builder: (context) {
            //               // ref
            //               //     .read(receiptFileProvider.notifier)
            //               //     .setReceiptImageFile(pickedImage);
            //               return VerifyReceiptDetails(pickedImage: pickedImage);
            //             },
            //             fullscreenDialog: true,
            //           ),
            //         );
            //       }
            //     }
            //   },
            // ),
            // const SizedBox(height: 16),
            FloatingActionButton(
              // heroTag: 'bookmarks',
              heroTag: null,
              backgroundColor: AppColors.subColor2,
              child: const Icon(Icons.bookmarks),
              onPressed: () {
                // Beamer.of(context).beamToNamed('/overview'),
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
                    MaterialPageRoute(
                      builder: (context) => const AddNewTransaction(),
                    ),
                  );
                  // Navigator.of(context, rootNavigator: true).push(
                  //   PageRouteBuilder(
                  //     pageBuilder: (context, animation, secondaryAnimation) =>
                  //         const AddNewTransaction(),
                  //     transitionDuration: const Duration(milliseconds: 200),
                  //     transitionsBuilder:
                  //         (context, animation, secondaryAnimation, child) {
                  //       final curvedAnimation = CurvedAnimation(
                  //         parent: animation,
                  //         curve: Curves.easeIn,
                  //         reverseCurve: Curves.easeIn,
                  //       );
                  //       return SlideTransition(
                  //         position: Tween<Offset>(
                  //           begin: const Offset(0, 1),
                  //           end: Offset.zero,
                  //         ).animate(curvedAnimation),
                  //         child: child,
                  //       );
                  //     },
                  //     // transitionsBuilder:
                  //     //     (context, animation, secondaryAnimation, child) {
                  //     //   return SlideTransition(
                  //     //     position: Tween<Offset>(
                  //     //       begin: const Offset(0, 1),
                  //     //       end: Offset.zero,
                  //     //     ).animate(animation),
                  //     //     child: child,
                  //     //   );
                  //     // },
                  //   ),
                  // );
                }),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<bool> getImage() async {
    String imagePath = join((await getApplicationSupportDirectory()).path,
        "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");
    try {
      bool success = await EdgeDetection.detectEdge(
        imagePath,
        canUseGallery: true,
        androidScanTitle: 'Scanning',
        androidCropTitle: 'Crop',
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: 'Reset',
      );

      debugPrint('isDetected: $success');

      if (success) {
        File imageFile = File(imagePath);
        Uint8List imageBytes = await imageFile.readAsBytes();
        Uint8List compressedBytes = Uint8List.fromList(
          await FlutterImageCompress.compressWithList(
            imageBytes,
            minWidth: 480,
            minHeight: 640,
            quality: 85,
            format: CompressFormat.jpeg,
          ),
        );
        await imageFile.writeAsBytes(compressedBytes);

        // scanReceipt(XFile(imagePath));
        debugPrint('imagePath = $imagePath');
        debugPrint('scan receipt completed!');

        if (!mounted) return false;

        debugPrint('mounted: $mounted');
        debugPrint('imagePath: $imagePath');

        ref
            .read(receiptStringPathProvider.notifier)
            .setReceiptStringPath(imagePath);
        // setState(() {
        //   _imagePath = imagePath;
        // });
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }
}
