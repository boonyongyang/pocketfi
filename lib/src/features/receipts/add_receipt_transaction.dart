import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/common_widgets/file_thumbnail_view.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/receipts/domain/receipt_text_rect.dart';
import 'package:pocketfi/src/features/receipts/scanned_text_page.dart';
import 'package:pocketfi/src/features/tags/application/tag_services.dart';
import 'package:pocketfi/src/features/tags/presentation/select_tag_widget.dart';
import 'package:pocketfi/src/features/wallets/application/wallet_services.dart';
import 'package:pocketfi/src/features/wallets/domain/wallet.dart';
import 'package:pocketfi/src/features/wallets/presentation/select_wallet_dropdownlist.dart';
import 'package:pocketfi/src/features/category/application/category_services.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/category/presentation/category_page.dart';
import 'package:pocketfi/src/features/bookmarks/application/bookmark_services.dart';
import 'package:pocketfi/src/features/transactions/application/transaction_services.dart';
import 'package:pocketfi/src/features/shared/date_picker/application/date_services.dart';
import 'package:pocketfi/src/features/shared/date_picker/presentation/transaction_date_picker.dart';
import 'package:pocketfi/src/features/tags/domain/taggie.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/shared/image_upload/data/image_file_notifier.dart';
import 'package:pocketfi/src/features/shared/image_upload/domain/file_type.dart';
import 'package:pocketfi/src/features/shared/image_upload/domain/thumbnail_request.dart';
import 'package:pocketfi/src/features/shared/image_upload/helpers/image_picker_helper.dart';
import 'package:pocketfi/src/features/transactions/presentation/add_new_transactions/category_selector_view.dart';
import 'package:pocketfi/src/features/shared/image_upload/presentation/full_screen_image_dialog.dart';
import 'package:pocketfi/src/features/transactions/presentation/add_new_transactions/select_transaction_type.dart';

class AddReceiptTransaction extends StatefulHookConsumerWidget {
  const AddReceiptTransaction({
    super.key,
    required this.imagePath,
    required this.recognizedText,
    required this.extractedTextRects,
  });

  final String? imagePath;
  final RecognizedText recognizedText;
  final List<ReceiptTextRect> extractedTextRects;

  @override
  AddReceiptTransactionState createState() => AddReceiptTransactionState();
}

class AddReceiptTransactionState extends ConsumerState<AddReceiptTransaction> {
  bool get isSelectedTransactionNull =>
      (ref.watch(selectedTransactionProvider)?.date == null);
  String _selectedRecurrence = 'Never';

  bool highlightMode = false;

  String? selectedPrice = '';
  DateTime? selectedDate;
  // String? selectedMerchant = '', selectedNote = '';
  late TextEditingController priceController,
      merchantController,
      noteController;

  final padding = const EdgeInsets.only(
    left: 24.0,
    right: 24.0,
    bottom: 4.0,
  );

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    final selectedWallet = ref.watch(selectedWalletProvider);
    final isBookmark = ref.watch(isBookmarkProvider);

    final scannedText = widget.recognizedText.text;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    priceController = useTextEditingController();
    noteController = useTextEditingController();
    merchantController = useTextEditingController();
    final isSaveButtonEnabled = useState(false);

    useEffect(
      () {
        void listener() =>
            isSaveButtonEnabled.value = priceController.text.isNotEmpty;
        priceController.addListener(listener);
        merchantController.addListener(listener);
        noteController.addListener(listener);
        return () {
          priceController.removeListener(listener);
          merchantController.removeListener(listener);
          noteController.removeListener(listener);
        };
      },
      [priceController, merchantController, noteController],
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        // FocusScopeNode currentFocus = FocusScope.of(context);
      },
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SelectTransactionType(noOfTabs: 3),
            TransactionAmountField(amountController: priceController),
            const SelectCurrency(),
            // * Select Category and Wallet
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 8.0),
                  SelectCategory(
                      categories: categories,
                      selectedCategory: selectedCategory),
                  const Spacer(),
                  const Icon(AppIcons.wallet, color: AppColors.mainColor1),
                  const SizedBox(width: 8.0),
                  const SelectWalletDropdownList(),
                  const SizedBox(width: 8.0),
                ],
              ),
            ),
            // * DatePicker, Note, Photo, Tags and Recurrence
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: TransactionDatePicker(initialDate: selectedDate),
                ),
                Padding(
                  padding: padding,
                  child: WriteOptionalNote(noteController: noteController),
                ),
                Padding(
                  padding: padding,
                  child: WriteOptionalMerchant(
                      merchantController: merchantController),
                ),
                SizedBox(
                  child: FutureBuilder<Size>(
                    future: getImageSize(widget.imagePath!),
                    builder:
                        (BuildContext context, AsyncSnapshot<Size> snapshot) {
                      if (snapshot.hasData) {
                        final imageSize = snapshot.data!;
                        const padding = 8.0;

                        final imageWidth = imageSize.width;
                        final imageHeight = imageSize.height;

                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  child: const CircleAvatar(
                                    radius: 22,
                                    backgroundColor: AppColors.mainColor1,
                                    child:
                                        Icon(Icons.document_scanner_outlined),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      highlightMode = !highlightMode;
                                      debugPrint(
                                          'highlight mode: $highlightMode');
                                    });
                                  },
                                ),
                                const SizedBox(width: 20.0),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ScannedTextPage(
                                            scannedText: scannedText),
                                      ),
                                    );
                                  },
                                  child: const Text('View scanned text'),
                                ),
                              ],
                            ),
                            Center(
                              child: SizedBox(
                                width: screenWidth * 0.9,
                                height: screenHeight * 0.8,
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(padding),
                                      child: Image.file(
                                        File(widget.imagePath!),
                                        fit: BoxFit.contain,
                                        width: imageWidth,
                                        height: imageHeight,
                                      ),
                                    ),
                                    if (highlightMode)
                                      ..._buildDetectedTextRects(context,
                                          imageSize, imageWidth, imageHeight),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                // selectPhoto(),
                // showIfPhotoIsAdded(),
                // Padding(
                //   padding: padding,
                //   child: selectTags(),
                // ),
                Padding(
                  padding: padding,
                  child: const SelectTagWidget(),
                ),
                Padding(
                  padding: padding,
                  child: selectReccurence(),
                ),
                Padding(
                  padding: padding,
                  child: Center(
                    child: Row(
                      children: [
                        IconButton(
                          splashRadius: 22,
                          icon: Icon(
                            isBookmark
                                ? Icons.bookmark
                                : Icons.bookmark_outline,
                            color: AppColors.mainColor2,
                            size: 32,
                          ),
                          onPressed: () {
                            ref
                                .read(isBookmarkProvider.notifier)
                                .toggleBookmark();

                            Fluttertoast.showToast(
                              msg: "Bookmark added",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.white,
                              textColor: AppColors.mainColor1,
                              fontSize: 16.0,
                            );
                          },
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: SaveButton(
                            isSaveButtonEnabled: isSaveButtonEnabled,
                            noteController: noteController,
                            amountController: priceController,
                            merchantController: merchantController,
                            imagePath: widget.imagePath!,
                            categoryName: selectedCategory,
                            mounted: mounted,
                            selectedWallet: selectedWallet,
                            isBookmark: isBookmark,
                            recognizedText: widget.recognizedText,
                            extractedTextRects: widget.extractedTextRects,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<Size> getImageSize(String imagePath) async {
    final File imageFile = File(imagePath);
    final Completer<Size> completer = Completer();
    final img = await decodeImageFromList(await imageFile.readAsBytes());
    completer.complete(Size(img.width.toDouble(), img.height.toDouble()));
    debugPrint('Image size: ${img.width} x ${img.height}');
    return completer.future;
  }

  List<Widget> _buildDetectedTextRects(BuildContext context, Size imageSize,
      double imageWidth, double imageHeight) {
    final List<Widget> rects = [];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const padding = 8.0;

    // Calculate scaling factors for width and height
    final double displayWidth = screenWidth * 0.9 - 2 * padding;
    final double displayHeight = screenHeight * 0.8 - 2 * padding;
    final double widthScale = displayWidth / imageSize.width;
    final double heightScale = displayHeight / imageSize.height;

    // Find the smaller scaling factor to maintain aspect ratio
    final double scale = min(widthScale, heightScale);

    // Calculate padding for centering the image in the SizedBox
    final double horizontalPadding =
        (displayWidth - imageSize.width * scale) / 2;
    final double verticalPadding =
        (displayHeight - imageSize.height * scale) / 2;

    for (ReceiptTextRect textRect in widget.extractedTextRects) {
      final rect = textRect.rect;

      rects.add(
        Positioned(
          left: rect.left * scale + padding + horizontalPadding,
          top: rect.top * scale + padding + verticalPadding,
          // child: GestureDetector(
          //   onTap: () {
          //     _showSnackBar(textRect.text);
          //   },
          child: GestureDetector(
            onTapDown: (TapDownDetails details) {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final Offset localOffset =
                  box.globalToLocal(details.globalPosition);
              debugPrint('Tapped at: ${localOffset.dx}, ${localOffset.dy}');
              _showMenu(
                textRect.text,
                context,
                details.globalPosition,
                (newValue) => setState(() => selectedPrice = newValue),
                priceController,
                merchantController,
                noteController,
              );

              _showSnackBar(textRect.text);
            },
            child: Container(
              width: rect.width * scale,
              height: rect.height * scale,
              decoration: BoxDecoration(
                color: AppColors.mainColor2.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      );
      debugPrint(
          'Rect: ${rect.left}, ${rect.top}, ${rect.width}, ${rect.height}');
    }
    debugPrint(
        'Screen size: ${MediaQuery.of(context).size.width} x ${MediaQuery.of(context).size.height}');
    return rects;
  }

  void _showMenu(
    String text,
    BuildContext context,
    Offset position,
    Function(String?) onSelectedPriceChanged,
    TextEditingController priceController,
    TextEditingController merchantController,
    TextEditingController noteController,
  ) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final double screenHeight = overlay.size.height;
    final double availableSpaceBelow = screenHeight - position.dy;
    final double availableSpaceAbove = position.dy;
    final bool enoughSpaceBelow = availableSpaceBelow > 150;
    final bool enoughSpaceAbove = availableSpaceAbove > 150;
    final bool showAbove = !enoughSpaceBelow && enoughSpaceAbove;

    final RelativeRect positionBox = RelativeRect.fromLTRB(
      position.dx,
      showAbove ? position.dy - 50 : position.dy,
      position.dx + 1,
      showAbove ? position.dy + 1 : position.dy + 50,
    );

    if (Platform.isAndroid) {
      showMenu(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        context: context,
        position: positionBox,
        items: [
          PopupMenuItem(
            enabled: false,
            child: Text('set \'$text\' as:'),
          ),
          PopupMenuItem(
            child: const Text('Merchant'),
            onTap: () => setState(() => merchantController.text = text),
          ),
          PopupMenuItem(
            child: const Text('Date'),
            onTap: () {
              extractAndSetDate(text);
            },
          ),
          PopupMenuItem(
            child: const Text('Note'),
            onTap: () => setState(() => noteController.text = text),
          ),
          PopupMenuItem(
            child: const Text('Total'),
            onTap: () {
              setState(() => selectedPrice = text);

              // Extract numbers and at most one decimal point
              String extractedNumber = '';
              bool hasDecimal = false;
              for (int i = 0; i < selectedPrice!.length; i++) {
                if (selectedPrice![i] == '.' && !hasDecimal) {
                  extractedNumber += '.';
                  hasDecimal = true;
                } else if (RegExp(r'\d').hasMatch(selectedPrice![i])) {
                  extractedNumber += selectedPrice![i];
                }
              }

              // Assign the extracted number to the priceController
              priceController.text = extractedNumber;
            },
          ),
        ],
      );
      // FIXME ios popup menu not working
      // } else if (Platform.isIOS) {
      //   showCupertinoModalPopup(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return CupertinoContextMenu(
      //         actions: [
      //           CupertinoContextMenuAction(
      //             child: const Text('Merchant'),
      //             onPressed: () => setState(() => merchantController.text = text),
      //           ),
      //           CupertinoContextMenuAction(
      //             child: const Text('Date'),
      //             onPressed: () {},
      //           ),
      //           CupertinoContextMenuAction(
      //             child: const Text('Note'),
      //             onPressed: () => setState(() => noteController.text = text),
      //           ),
      //           CupertinoContextMenuAction(
      //             child: const Text('Total'),
      //             onPressed: () {
      //               setState(() => selectedPrice = text);

      //               // Extract numbers and at most one decimal point
      //               String extractedNumber = '';
      //               bool hasDecimal = false;
      //               for (int i = 0; i < selectedPrice!.length; i++) {
      //                 if (selectedPrice![i] == '.' && !hasDecimal) {
      //                   extractedNumber += '.';
      //                   hasDecimal = true;
      //                 } else if (RegExp(r'\d').hasMatch(selectedPrice![i])) {
      //                   extractedNumber += selectedPrice![i];
      //                 }
      //               }

      //               // Assign the extracted number to the priceController
      //               priceController.text = extractedNumber;
      //             },
      //           ),
      //         ],
      //         child: Container(
      //           color: Colors.blueGrey,
      //           width: 20.0,
      //           height: 20.0,
      //         ),
      //         // previewBuilder: (BuildContext context, Animation<double> animation,
      //         //     Widget child) {
      //         //   return Center(
      //         //     child: Text(
      //         //       'set \'$text\' as:',
      //         //       style: const TextStyle(fontSize: 16),
      //         //     ),
      //         //   );
      //         // },
      //       );
      //     },
      //   );
    }
  }

  void _showSnackBar(String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void extractAndSetDate(String text) {
    // Extract a date in format MM/dd/yyyy or dd/MM/yyyy from the string
    final RegExp dateRegExp =
        RegExp(r'(?:(\d{1,2})[\/.-](\d{1,2})[\/.-](\d{2}(?:\d{2})?))');
    final match = dateRegExp.firstMatch(text);

    if (match != null) {
      int day, month, year;

      // You can switch the month and day groups based on your date format
      day = int.parse(match.group(1)!);
      month = int.parse(match.group(2)!);
      year = int.parse(match.group(3)!);

      // If the year is two digits, adjust it to a four-digit year
      if (year < 100) {
        year += (year < 50 ? 2000 : 1900);
      }

      setState(() {
        selectedDate = DateTime(year, month, day);
      });
    }
  }

  Row selectPhoto() {
    return Row(
      children: [
        const Icon(Icons.photo, color: AppColors.mainColor1),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: () async {
              final imageFile = await ImagePickerHelper.pickImageFromGallery();
              if (imageFile == null) return;
              ref.read(imageFileProvider.notifier).setImageFile(imageFile);
              // ref.refresh(postSettingProvider);
              if (!mounted) return;
              displayPhoto(imageFile);
            },
            child: const Text(
              Strings.selectPhoto,
            ),
          ),
        ),
        const Spacer(),
        if (ref.read(imageFileProvider) != null)
          IconButton(
            color: AppColors.mainColor1,
            icon: const Icon(Icons.close),
            onPressed: () {
              // ref.read(imageFileProvider.notifier).setImageFile(null);
              ref.read(imageFileProvider.notifier).clearImageFile();
            },
          ),
      ],
    );
  }

  void displayPhoto(File imageFile) {
    debugPrint('image file path: ${imageFile.path}');

    FileThumbnailView(
      thumbnailRequest: ThumbnailRequest(
        imageFile,
        FileType.image,
      ),
    );

    ref.read(imageFileProvider.notifier).setImageFile(imageFile);
  }

  Widget showIfPhotoIsAdded() {
    final imageFile = ref.watch(imageFileProvider);
    return (imageFile != null)
        ? InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      FullScreenImageDialog(imageFile: imageFile),
                  fullscreenDialog: true,
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: 150.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(imageFile),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          )
        : const SizedBox();
  }

  // Row selectTags() {
  //   return Row(
  //     children: [
  //       const Icon(
  //         Icons.label_important_rounded,
  //         color: AppColors.mainColor1,
  //       ),
  //       const SizedBox(width: 14.0),
  //       Expanded(
  //         child: SingleChildScrollView(
  //           scrollDirection: Axis.horizontal,
  //           child: Wrap(
  //             direction: Axis.horizontal,
  //             spacing: 8.0,
  //             children: [
  //               for (final tag in tags)
  //                 FilterChip(
  //                   showCheckmark: false,
  //                   selectedColor: AppColors.mainColor2,
  //                   label: Text(tag.label),
  //                   selected: selectedTags.contains(tag),
  //                   onSelected: (selected) {
  //                     setState(
  //                       () {
  //                         if (selected) {
  //                           selectedTags.add(tag);
  //                         } else {
  //                           selectedTags.remove(tag);
  //                         }
  //                       },
  //                     );
  //                   },
  //                 ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Row selectReccurence() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Recurrence:'),
        DropdownButton(
          items: const [
            DropdownMenuItem(
              value: 'Never',
              child: Text('Never'),
            ),
            DropdownMenuItem(
              value: 'Everyday',
              child: Text('Everyday'),
            ),
            DropdownMenuItem(
              value: 'Every Work Day',
              child: Text('Every Work Day'),
            ),
            DropdownMenuItem(
              value: 'Every Week',
              child: Text('Every Week'),
            ),
            DropdownMenuItem(
              value: 'Every 2 Weeks',
              child: Text('Every 2 Weeks'),
            ),
            DropdownMenuItem(
              value: 'Every Month',
              child: Text('Every Month'),
            ),
            DropdownMenuItem(
              value: 'Every Year',
              child: Text('Every Year'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedRecurrence = value!;
            });
          },
          value: _selectedRecurrence,
        ),
      ],
    );
  }
}

class SelectCategory extends ConsumerWidget {
  const SelectCategory({
    super.key,
    required this.categories,
    required this.selectedCategory,
  });

  final List<Category> categories;
  final Category? selectedCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Builder(
      builder: (context) {
        return Center(
          child: GestureDetector(
            child: CategorySelectorView(selectedCategory: selectedCategory),
            onTap: () {
              showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.0),
                  ),
                ),
                barrierColor: Colors.black.withOpacity(0.5),
                context: context,
                builder: (context) {
                  return SizedBox(
                    height: 400,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(Strings.selectCategory,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                              IconButton(
                                // icon: const Icon(Icons.add_outlined),
                                icon: const Icon(Icons.settings),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CategoryPage(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 8.0,
                              // mainAxisSpacing: 8.0,
                            ),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    // ref
                                    //             .watch(
                                    //                 selectedTransactionProvider)
                                    //             ?.categoryName ==
                                    //         null
                                    //     ? ref
                                    //         .read(selectedCategoryProvider
                                    //             .notifier)
                                    //         .state = categories[index]
                                    //     : ref
                                    //         .read(selectedTransactionProvider
                                    //             .notifier)
                                    //         .updateCategory(
                                    //             categories[index], ref);

                                    ref
                                        .read(selectedCategoryProvider.notifier)
                                        .state = categories[index];

                                    debugPrint(
                                        'selected category: ${categories[index].name}');
                                    Navigator.of(context).pop();
                                  },
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor:
                                            categories[index].color,
                                        child: categories[index].icon,
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        categories[index].name,
                                        style: const TextStyle(fontSize: 12.0),
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class SelectCurrency extends StatelessWidget {
  const SelectCurrency({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text('MYR',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.mainColor1,
        ));
  }
}

class TransactionAmountField extends ConsumerWidget {
  const TransactionAmountField({
    Key? key,
    required this.amountController,
  }) : super(key: key);

  final TextEditingController amountController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 250,
      child: AutoSizeTextField(
        autofocus: true,
        textAlign: TextAlign.center,
        enableInteractiveSelection: false,
        showCursor: false,
        // keyboardType: const TextInputType.numberWithOptions(
        //   decimal: true,
        //   signed: true,
        // ),
        // textInputAction: TextInputAction.done,
//        keyboardType: Platform\.isIOS
//            \? const //TextInputType\.numberWithOptions\(
//               // signed: true,
//                decimal: true,
//              \)
//            : TextInputType\.number,
        keyboardType: TextInputType.number,
// This regex for only amount (price). you can create your own regex based on your requirement
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}'))
        ],
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: Strings.zeroAmount,
        ),
        controller: amountController,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: ref.watch(transactionTypeProvider) == TransactionType.expense
              ? AppColors.red
              : ref.watch(transactionTypeProvider) == TransactionType.income
                  ? AppColors.green
                  : Colors.grey,
        ),
      ),
    );
  }
}

class WriteOptionalNote extends StatelessWidget {
  const WriteOptionalNote({
    super.key,
    required TextEditingController noteController,
  }) : _noteController = noteController;

  final TextEditingController _noteController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.mode, color: AppColors.mainColor1),
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 250,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: TextField(
              // autofocus: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Write a note',
              ),
              controller: _noteController,
              onSubmitted: (_) => FocusScope.of(context).nextFocus(),
            ),
          ),
        ),
      ],
    );
  }
}

class WriteOptionalMerchant extends StatelessWidget {
  const WriteOptionalMerchant({
    super.key,
    required TextEditingController merchantController,
  }) : _merchantController = merchantController;

  final TextEditingController _merchantController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.store, color: AppColors.mainColor1),
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 250,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: TextField(
              // autofocus: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Merchant name',
              ),
              controller: _merchantController,
              onSubmitted: (_) => FocusScope.of(context).nextFocus(),
            ),
          ),
        ),
      ],
    );
  }
}

class SaveButton extends ConsumerWidget {
  const SaveButton({
    super.key,
    required this.isSaveButtonEnabled,
    required this.noteController,
    required this.amountController,
    required this.merchantController,
    required this.categoryName,
    required this.selectedWallet,
    required this.mounted,
    required this.imagePath,
    required this.recognizedText,
    required this.extractedTextRects,
    this.isBookmark = false,
    // required this.date,
  });

  final ValueNotifier<bool> isSaveButtonEnabled;
  final TextEditingController noteController;
  final TextEditingController amountController;
  final TextEditingController merchantController;
  final Category? categoryName;
  final Wallet? selectedWallet;
  final bool mounted;
  final bool isBookmark;
  final String imagePath;
  final RecognizedText recognizedText;
  final List<ReceiptTextRect> extractedTextRects;
  // final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FullWidthButtonWithText(
      padding: 0,
      text: Strings.save,
      backgroundColor: AppColors.mainColor2,
      onPressed: isSaveButtonEnabled.value
          ? () async {
              final userId = ref.read(userIdProvider);
              final type = ref.read(transactionTypeProvider);
              final date = ref.read(transactionDateProvider);
              // final file = ref.read(imageFileProvider);
              final tags = ref.watch(userTagsNotifier);

              final List<String> selectedTagNames = tags.isNotEmpty
                  ? tags
                      .where((element) => element.isSelected)
                      .map((e) => e.name)
                      .toList()
                  : [];

              debugPrint('userId is: $userId');
              debugPrint('transactionType is: $type');

              if (userId == null) {
                return;
              }
              final note = noteController.text;
              final amount = amountController.text;
              final merchant = merchantController.text;
              // final selectedCategory =
              //     ref.read(selectedCategoryProvider).state;
              debugPrint('note is: $note');
              debugPrint('amount is: $amount');

              debugPrint('walletName is: ${selectedWallet!.walletId}');

              final isCreated = await ref
                  .read(transactionProvider.notifier)
                  .addNewReceiptTransaction(
                    userId: userId,
                    walletId: selectedWallet!.walletId, // ? sure?
                    walletName: selectedWallet!.walletName, // ? sure?
                    amount: double.parse(amount),
                    merchant: merchant,
                    type: type,
                    note: note,
                    categoryName: categoryName!.name,
                    date: date,
                    imagePath: imagePath,
                    recognizedText: recognizedText,
                    extractedTextRects: extractedTextRects,
                    isBookmark: isBookmark,
                    tags: selectedTagNames,
                  );
              debugPrint('isCreated is: $isCreated');

              if (isCreated && mounted) {
                // if (isBookmark) {
                //   ref.read(bookmarkTransactionListProvider.notifier).addBookmark(
                //         Transaction(
                //           transactionId: ,
                //           userId: userId,
                //           walletId: selectedWallet!.walletId,
                //           amount: double.parse(amount),
                //           type: type,
                //           description: note,
                //           categoryName: categoryName!.name,
                //           date: date,
                //           file: file,
                //         ),
                //         // userId: userId,
                //         // walletId: selectedWallet!.walletId,
                //         // amount: double.parse(amount),
                //         // type: type,
                //         // note: note,
                //         // categoryName: categoryName!.name,
                //         // date: date,
                //         // file: file,
                //       );
                // }

                noteController.clear();
                amountController.clear();
                Navigator.of(context).pop();

                // reset the state of the provider
                resetCategoryState(ref);
                ref
                    .read(transactionTypeProvider.notifier)
                    .setTransactionType(0);

                // clear the imageFileProvider
                // ref.read(imageFileProvider.notifier).setImageFile(null);
                ref.read(imageFileProvider.notifier).clearImageFile();

                ref
                    .read(transactionDateProvider.notifier)
                    .setDate(DateTime.now());

                ref.read(isBookmarkProvider.notifier).resetBookmarkState();

                // show snackbar to notify the user
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //     content: Text('Transaction added'),
                //   ),
                // );
                Fluttertoast.showToast(
                  msg: "Transaction added",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.white,
                  textColor: AppColors.mainColor1,
                  fontSize: 16.0,
                );
              }
            }
          : null,
    );
  }
}
