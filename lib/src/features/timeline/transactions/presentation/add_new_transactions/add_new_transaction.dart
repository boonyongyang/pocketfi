// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/common_widgets/file_thumbnail_view.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/data/user_wallets_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet.dart';
import 'package:pocketfi/src/features/budget/wallet/presentation/select_wallet_dropdownlist.dart';
import 'package:pocketfi/src/features/category/application/category_providers.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/category/presentation/category_page.dart';
import 'package:pocketfi/src/features/timeline/bookmarks/application/bookmark_services.dart';
import 'package:pocketfi/src/features/timeline/transactions/application/transaction_providers.dart';
import 'package:pocketfi/src/features/timeline/transactions/data/transaction_notifiers.dart';
import 'package:pocketfi/src/features/timeline/transactions/date_picker/application/selected_date_notifier.dart';
import 'package:pocketfi/src/features/timeline/transactions/date_picker/presentation/transaction_date_picker.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/tag.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/shared/image_upload/data/image_file_notifier.dart';
import 'package:pocketfi/src/features/shared/image_upload/domain/file_type.dart';
import 'package:pocketfi/src/features/shared/image_upload/domain/thumbnail_request.dart';
import 'package:pocketfi/src/features/shared/image_upload/helpers/image_picker_helper.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/add_new_transactions/category_selector_view.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/add_new_transactions/full_screen_image_dialog.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/add_new_transactions/select_transaction_type.dart';

class AddNewTransaction extends StatefulHookConsumerWidget {
  const AddNewTransaction({
    super.key,
  });

  @override
  AddNewTransactionState createState() => AddNewTransactionState();
}

class AddNewTransactionState extends ConsumerState<AddNewTransaction> {
  bool get isSelectedTransactionNull =>
      (ref.watch(selectedTransactionProvider)?.date == null);
  String _selectedRecurrence = 'Never';

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    final selectedWallet = ref.watch(selectedWalletProvider);
    final isBookmark = ref.watch(isBookmarkProvider);

    final amountController = useTextEditingController();
    final noteController = useTextEditingController();
    final isSaveButtonEnabled = useState(false);

    useEffect(
      () {
        void listener() =>
            isSaveButtonEnabled.value = amountController.text.isNotEmpty;
        amountController.addListener(listener);
        return () => amountController.removeListener(listener);
      },
      [amountController],
    );

    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        // elevation: 0,
        backgroundColor: AppColors.mainColor1,
        shadowColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          Strings.newTransaction,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: AppColors.white,
          ),
          onPressed: () {
            // ref.read(selectedCategoryProvider.notifier).state = null;

            Navigator.of(context).pop();
            resetCategoryState(ref);
            // ref.read(transactionTypeProvider.notifier).setTransactionType(0);
            ref
                .read(transactionTypeProvider.notifier)
                .resetTransactionTypeState();

            // ref.read(transactionDateProvider.notifier).setDate(DateTime.now());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          // color: Colors.grey,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            children: [
              const SelectTransactionType(noOfTabs: 3),
              TransactionAmountField(amountController: amountController),
              const SelectCurrency(),
              // * Select Category and Wallet
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    // TransactionDatePicker(
                    //     // date: DateTime.now(),
                    //     ),
                    const TransactionDatePicker(),
                    WriteOptionalNote(noteController: noteController),
                    selectPhoto(),
                    showIfPhotoIsAdded(),
                    const SizedBox(height: 8.0),
                    selectTags(),
                    selectReccurence(),
                    Center(
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

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Bookmark added!'),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 100,
                            child: SaveButton(
                              isSaveButtonEnabled: isSaveButtonEnabled,
                              noteController: noteController,
                              amountController: amountController,
                              categoryName: selectedCategory,
                              mounted: mounted,
                              selectedWallet: selectedWallet,
                              isBookmark: isBookmark,
                              // date: ,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row selectPhoto() {
    return Row(
      children: [
        const Icon(Icons.photo_camera_outlined, color: AppColors.mainColor1),
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
              ref.read(imageFileProvider.notifier).setImageFile(null);
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

  Row selectTags() {
    return Row(
      children: [
        const Icon(
          Icons.label_outline,
          color: AppColors.mainColor1,
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 8.0,
              children: [
                for (final tag in tags)
                  FilterChip(
                    showCheckmark: false,
                    selectedColor: AppColors.mainColor2,
                    label: Text(tag.label),
                    selected: selectedTags.contains(tag),
                    onSelected: (selected) {
                      setState(
                        () {
                          if (selected) {
                            selectedTags.add(tag);
                          } else {
                            selectedTags.remove(tag);
                          }
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

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
                                    ref
                                                .watch(
                                                    selectedTransactionProvider)
                                                ?.categoryName ==
                                            null
                                        ? ref
                                            .read(selectedCategoryProvider
                                                .notifier)
                                            .state = categories[index]
                                        : ref
                                            .read(selectedTransactionProvider
                                                .notifier)
                                            .updateCategory(
                                                categories[index], ref);

                                    debugPrint(
                                        'selected category: ${categories[index].name}');
                                    Navigator.of(context).pop();
                                  },
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    // mainAxisSize: MainAxisSize.min,
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
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
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
        const Icon(Icons.note_add_outlined, color: AppColors.mainColor1),
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
                hintText: 'write a note',
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

class SaveButton extends ConsumerWidget {
  const SaveButton({
    super.key,
    required this.isSaveButtonEnabled,
    required this.noteController,
    required this.amountController,
    required this.categoryName,
    required this.selectedWallet,
    required this.mounted,
    this.isBookmark = false,
    // required this.date,
  });

  final ValueNotifier<bool> isSaveButtonEnabled;
  final TextEditingController noteController;
  final TextEditingController amountController;
  final Category? categoryName;
  final Wallet? selectedWallet;
  final bool mounted;
  final bool isBookmark;
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
              final file = ref.read(imageFileProvider);

              debugPrint('userId is: $userId');
              debugPrint('transactionType is: $type');

              if (userId == null) {
                return;
              }
              final note = noteController.text;
              final amount = amountController.text;
              // final selectedCategory =
              //     ref.read(selectedCategoryProvider).state;
              debugPrint('note is: $note');
              debugPrint('amount is: $amount');

              debugPrint('walletName is: ${selectedWallet!.walletId}');

              final isCreated = await ref
                  .read(createNewTransactionProvider.notifier)
                  .createNewTransaction(
                    userId: userId,
                    walletId: selectedWallet!.walletId, // ? sure?
                    amount: double.parse(amount),
                    type: type,
                    note: note,
                    categoryName: categoryName!.name,
                    date: date,
                    file: file,
                    isBookmark: isBookmark,
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
                ref.read(imageFileProvider.notifier).setImageFile(null);

                ref
                    .read(transactionDateProvider.notifier)
                    .setDate(DateTime.now());

                ref.read(isBookmarkProvider.notifier).resetBookmarkState();

                // show snackbar to notify the user
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Transaction added'),
                  ),
                );
              }
            }
          : null,
    );
  }
}
