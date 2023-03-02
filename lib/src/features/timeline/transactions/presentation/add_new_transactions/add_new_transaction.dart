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
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/data/user_wallets_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet.dart';
import 'package:pocketfi/src/features/category/application/category_providers.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/timeline/posts/post_settings/application/post_setting_provider.dart';
import 'package:pocketfi/src/features/timeline/transactions/application/transaction_provider.dart';
import 'package:pocketfi/src/features/timeline/transactions/date_picker/application/selected_date_notifier.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/tag.dart';
import 'package:pocketfi/src/features/timeline/transactions/image_upload/application/image_uploader_provider.dart';
import 'package:pocketfi/src/features/timeline/transactions/image_upload/data/image_file_notifier.dart';
import 'package:pocketfi/src/features/timeline/transactions/image_upload/domain/file_type.dart';
import 'package:pocketfi/src/features/timeline/transactions/image_upload/domain/thumbnail_request.dart';
import 'package:pocketfi/src/features/timeline/transactions/image_upload/helpers/image_picker_helper.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/add_new_transactions/category_selector_view.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/add_new_transactions/full_screen_image_dialog.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/add_new_transactions/select_transaction_type.dart';
import 'package:pocketfi/src/features/timeline/transactions/date_picker/presentation/transaction_date_picker.dart';

class AddNewTransaction extends StatefulHookConsumerWidget {
  const AddNewTransaction({
    super.key,
  });

  @override
  AddNewTransactionState createState() => AddNewTransactionState();
}

class AddNewTransactionState extends ConsumerState<AddNewTransaction> {
  File? _imageFile;

  String _selectedRecurrence = 'Never';
  String _selectedWallet = 'Personal';

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    final wallets = ref.watch(userWalletsProvider);
    final selectedWallet = ref.watch(selectedWalletProvider);

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
            // access ref inside the onPressed callback
            // ref.read(selectedCategoryProvider.notifier).state = null;

            Navigator.of(context).pop();
            resetCategoryState(ref);
            ref.read(transactionTypeProvider.notifier).setTransactionType(0);
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
              const SelectTransactionType(
                noOfTabs: 3,
              ),
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
                        // ref: ref,
                        selectedCategory: selectedCategory),
                    const Spacer(),
                    const Icon(AppIcons.wallet, color: AppColors.mainColor1),
                    const SizedBox(width: 8.0),
                    SelectWallet(
                        // ref: ref,
                        selectedWallet: selectedWallet,
                        wallets: wallets.value),
                    // selectWallet(),
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
                    const TransactionDatePicker(),
                    WriteOptionalNote(noteController: noteController),
                    addPhoto(),
                    showIfPhotoIsAdded(),
                    const SizedBox(height: 8.0),
                    selectTags(),
                    selectReccurence(),
                    Center(
                      child: Row(
                        children: [
                          // IconButton(
                          //   icon: const Icon(
                          //     Icons.bookmark_outline,
                          //     color: AppColors.mainColor1,
                          //   ),
                          //   onPressed: () {
                          //     ref
                          //         .read(postSettingProvider.notifier)
                          //         .toggleBookmark();
                          //   },
                          // ),
                          IconButton(
                            // splashRadius: 24 / 1.2,
                            splashRadius: 22,
                            icon: const Icon(
                              Icons.bookmark_outline,
                              color: AppColors.mainColor1,
                              size: 32,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Bookmark'),
                                ),
                              );
                            },
                          ),

                          SizedBox(
                            width: MediaQuery.of(context).size.width - 100,
                            child: SaveButton(
                              isSaveButtonEnabled: isSaveButtonEnabled,
                              ref: ref,
                              noteController: noteController,
                              amountController: amountController,
                              categoryName: selectedCategory,
                              mounted: mounted,
                              selectedWallet: selectedWallet,
                              file: null,
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

  DropdownButton<String> selectWallet() {
    return DropdownButton<String>(
      items: const [
        DropdownMenuItem(
          value: 'Personal',
          child: Text('Personal'),
        ),
        DropdownMenuItem(
          value: 'Shared',
          child: Text('Shared'),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _selectedWallet = value!;
        });
      },
      value: _selectedWallet,
    );
  }

  Row addPhoto() {
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
              Strings.addAPhoto,
            ),
          ),
        ),
      ],
    );
  }

  // void displayPhoto(File imageFile) {
  //   // display thumnail of the image
  //   debugPrint('image file path: ${imageFile.path}');

  //   FileThumbnailView(
  //     thumbnailRequest: ThumbnailRequest(
  //       imageFile,
  //       FileType.image,
  //     ),
  //   );

  //   setState(() {
  //     _imageFile = imageFile;
  //     debugPrint('show Picture');
  //   });
  // }

  void displayPhoto(File imageFile) {
    // display thumnail of the image
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
              height: 150,
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

class SelectWallet extends ConsumerWidget {
  const SelectWallet({
    super.key,
    // required this.ref,
    required this.wallets,
    required this.selectedWallet,
  });

  // final WidgetRef ref;
  final Iterable<Wallet>? wallets;
  final Wallet? selectedWallet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final wallets = ref.watch(userWalletsProvider);
    // final selectedWallet = ref.watch(selectedWalletProvider);

    debugPrint('first wallets: ${selectedWallet?.walletName}');
    final walletList = wallets?.toList();
    debugPrint('wallet list: ${walletList?.length}');

    return Consumer(
      builder: (context, ref, child) {
        return DropdownButton(
          value: selectedWallet,
          items: walletList?.map((wallet) {
            return DropdownMenuItem(
              value: wallet,
              child: Text(wallet.walletName),
            );
          }).toList(),
          onChanged: (selectedWallet) {
            debugPrint('wallet tapped: ${selectedWallet?.walletName}');
            ref.read(selectedWalletProvider.notifier).state = selectedWallet!;
            debugPrint(
                'selected wallet: ${ref.read(selectedWalletProvider)?.walletName}');
          },
        );
      },
    );
  }
}
// return Center(
//   child: wallets.when(
//     data: (Iterable<Wallet> data) {
//       // final walletList = data?.toList() ?? [];
//       final walletList = data.toList();
//       return DropdownButton(
//         // value: walletList.isNotEmpty ? walletList.first : null,
//         value: selectedWallet,
//         items: walletList.map((wallet) {
//           return DropdownMenuItem(
//             value: wallet,
//             child: Text(wallet.walletName),
//           );
//         }).toList(),
//         onChanged: (selectedWallet) {
//           debugPrint('wallet tapped: ${selectedWallet?.walletName}');
//           ref.read(selectedWalletProvider.notifier).state = selectedWallet!;
//           debugPrint(
//               'selected wallet: ${ref.read(selectedWalletProvider)?.walletName}');
//         },
//       );
//     },
//     loading: () => const CircularProgressIndicator(),
//     error: (error, stackTrace) => Text('Error: $error'),
//   ),
// );

class SelectCategory extends ConsumerWidget {
  const SelectCategory({
    super.key,
    // required this.ref,
    required this.categories,
    required this.selectedCategory,
  });

  // final WidgetRef ref;
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
                        const SizedBox(height: 8.0),
                        const Text(Strings.selectCategory),
                        const SizedBox(height: 8.0),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                            ),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  ref
                                      .read(selectedCategoryProvider.notifier)
                                      .state = categories[index];

                                  debugPrint(
                                      'selected category: ${categories[index].name}');
                                  Navigator.of(context).pop();
                                },
                                leading: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: categories[index].color,
                                      child: categories[index].icon,
                                    ),
                                    Text(categories[index].name),
                                  ],
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

class TransactionAmountField extends StatelessWidget {
  const TransactionAmountField({
    super.key,
    required this.amountController,
  });

  final TextEditingController amountController;

  @override
  Widget build(BuildContext context) {
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
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.red,
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

class SaveButton extends StatelessWidget {
  const SaveButton({
    super.key,
    required this.isSaveButtonEnabled,
    required this.ref,
    required this.noteController,
    required this.amountController,
    required this.categoryName,
    required this.selectedWallet,
    required this.file,
    required this.mounted,
  });

  final ValueNotifier<bool> isSaveButtonEnabled;
  final WidgetRef ref;
  final TextEditingController noteController;
  final TextEditingController amountController;
  final Category? categoryName;
  final Wallet? selectedWallet;
  final File? file;
  final bool mounted;

  @override
  Widget build(BuildContext context) {
    return FullWidthButtonWithText(
      padding: 0,
      text: Strings.save,
      backgroundColor: AppColors.mainColor2,
      onPressed: isSaveButtonEnabled.value
          ? () async {
              final userId = ref.read(userIdProvider);
              final type = ref.read(transactionTypeProvider);
              final date = ref.read(selectedDateProvider);
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

              // hooking the UI to the provider will cause the UI to rebuild
              final isCreated = await ref
                  .read(createNewTransactionProvider.notifier)
                  .createNewTransaction(
                    userId: userId,
                    amount: double.parse(amount),
                    type: type,
                    note: note,
                    categoryName: categoryName!.name,
                    // walletName: selectedWallet!.walletName,
                    walletId: selectedWallet!.walletId,
                    date: date,
                    file: file,
                  );
              debugPrint('isCreated is: $isCreated');

              if (isCreated && mounted) {
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
