import 'dart:io';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/common_widgets/file_thumbnail_view.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/category/application/category_providers.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/timeline/posts/post_settings/application/post_setting_provider.dart';
import 'package:pocketfi/src/features/timeline/transactions/application/transaction_provider.dart';
import 'package:pocketfi/src/features/timeline/transactions/data/transaction_type_notifier.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/tag.dart';
import 'package:pocketfi/src/features/timeline/transactions/image_upload/domain/file_type.dart';
import 'package:pocketfi/src/features/timeline/transactions/image_upload/domain/thumbnail_request.dart';
import 'package:pocketfi/src/features/timeline/transactions/image_upload/helpers/image_picker_helper.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/add_new_transactions/category_selector_view.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/add_new_transactions/full_screen_image_dialog.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/add_new_transactions/select_transaction_type.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/add_new_transactions/transaction_date_picker.dart';

class AddNewTransaction extends StatefulHookConsumerWidget {
  const AddNewTransaction({
    super.key,
  });

  @override
  AddNewTransactionState createState() => AddNewTransactionState();
}

class AddNewTransactionState extends ConsumerState<AddNewTransaction> {
  File? _imageFile;

  List<TagChip> tags = [
    TagChip(
      label: 'Lunch',
      onSelected: () {},
      selected: false,
    ),
    TagChip(
      label: 'Dinner',
      onSelected: () {},
      selected: false,
    ),
    TagChip(
      label: 'Rent',
      onSelected: () {},
      selected: false,
    ),
    TagChip(
      label: 'Parking',
      onSelected: () {},
      selected: false,
    ),
    TagChip(
      label: 'Movie',
      onSelected: () {},
      selected: false,
    ),
    TagChip(
      label: 'asdf',
      onSelected: () {},
      selected: false,
    ),
    TagChip(
      label: 'dfsdfsd',
      onSelected: () {},
      selected: false,
    ),
    TagChip(
      label: 'Ressnt',
      onSelected: () {},
      selected: false,
    ),
    TagChip(
      label: 's',
      onSelected: () {},
      selected: false,
    ),
    TagChip(
      label: 'dfs',
      onSelected: () {},
      selected: false,
    ),
  ];

  List<TagChip> selectedTags = [];

  String _selectedRecurrence = 'Never';
  String _selectedWallet = 'Personal';

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);

    final selectedCategory = ref.watch(selectedCategoryProvider);

    final amountController = useTextEditingController();
    final noteController = useTextEditingController();
    final isSaveButtonEnabled = useState(false);

    useEffect(
      () {
        void listener() {
          isSaveButtonEnabled.value = amountController.text.isNotEmpty;
        }

        amountController.addListener(listener);

        return () {
          amountController.removeListener(listener);
        };
      },
      [
        amountController,
      ],
    );

    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        // elevation: 0,
        // backgroundColor: Colors.transparent,
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
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          // color: Colors.grey,
          padding: EdgeInsets.only(
            // top: 50,
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Transform.scale(
                    scale: 0.83, child: const SelectTransactionType()),
              ),
              SizedBox(
                width: 250,
                // color: Colors.grey[300],
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
              ),
              const Text('MYR',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mainColor1,
                  )),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 8.0),
                    Builder(
                      builder: (context) {
                        return Center(
                          child: GestureDetector(
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
                                    height: 300,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 8.0),
                                        const Text(Strings.selectCategory),
                                        const SizedBox(height: 8.0),

                                        // // use flutter layout grid package to create grid
                                        // flutter_layout_grid
                                        // LayoutGrid(
                                        //   columnGap: 8,
                                        //   rowGap: 8,
                                        //   columnSizes: const [
                                        //     FlexibleTrackSize(1),
                                        //     FlexibleTrackSize(1),
                                        //     FlexibleTrackSize(1),
                                        //     FlexibleTrackSize(1),
                                        //   ],
                                        //   rowSizes: const [
                                        //     FlexibleTrackSize(1),
                                        //     FlexibleTrackSize(1),
                                        //     FlexibleTrackSize(1),
                                        //     FlexibleTrackSize(1),
                                        //     FlexibleTrackSize(1),
                                        //   ],
                                        //   children: [
                                        //     for (var category in categories)
                                        //       GestureDetector(
                                        //         onTap: () {
                                        //           ref
                                        //               .read(
                                        //                   selectedCategoryProvider
                                        //                       .notifier)
                                        //               .state = category;
                                        //           Navigator.of(context).pop();
                                        //         },
                                        //         child: Container(
                                        //           decoration: BoxDecoration(
                                        //             color: category.color,
                                        //             borderRadius:
                                        //                 BorderRadius.circular(
                                        //                     8),
                                        //           ),
                                        //           child: Center(
                                        //             child: category.icon,
                                        //           ),
                                        //         ),
                                        //       ),
                                        //   ],
                                        // ),

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
                                                      .read(
                                                          selectedCategoryProvider
                                                              .notifier)
                                                      .state = categories[index];
                                                  Navigator.of(context).pop();
                                                },
                                                leading: Column(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundColor:
                                                          categories[index]
                                                              .color,
                                                      child: categories[index]
                                                          .icon,
                                                    ),
                                                    Text(
                                                        categories[index].name),
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
                            child: CategorySelectorView(
                                selectedCategory: selectedCategory),
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                    const Icon(AppIcons.wallet, color: AppColors.mainColor1),
                    const SizedBox(width: 8.0),
                    DropdownButton<String>(
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
                    ),
                    const SizedBox(width: 8.0),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const TransactionDatePicker(),
                    WriteOptionalNote(noteController: noteController),
                    Row(
                      children: [
                        const Icon(Icons.photo_camera_outlined,
                            color: AppColors.mainColor1),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: () async {
                              // pick a image first
                              final imageFile = await ImagePickerHelper
                                  .pickImageFromGallery();
                              if (imageFile == null) {
                                return;
                              }

                              ref.refresh(postSettingProvider);

                              if (!mounted) {
                                return;
                              }

                              displayPhoto(imageFile);
                            },
                            child: const Text(
                              Strings.addAPhoto,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_imageFile != null)
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  FullScreenImageDialog(imageFile: _imageFile!),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(_imageFile!),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.catching_pokemon_sharp,
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
                    ),
                    selectReccurence(),
                    FullWidthButtonWithText(
                      text: 'Save',
                      onPressed: isSaveButtonEnabled.value
                          ? () async {
                              final userId = ref.read(
                                userIdProvider,
                              );
                              final type = ref.read(transactionTypeProvider);

                              debugPrint('userId is: $userId');
                              debugPrint('tType is: $type');

                              if (userId == null) {
                                return;
                              }
                              final note = noteController.text;
                              final amount = amountController.text;
                              // final selectedCategory =
                              //     ref.read(selectedCategoryProvider).state;
                              debugPrint('note is: $note');
                              debugPrint('amount is: $amount');

                              // hook the UI to the imageUploadProvider for uploading the post
                              // hooking the UI to the provider will cause the UI to rebuild
                              final isCreated = await ref
                                  .read(createNewTransactionProvider.notifier)
                                  .createNewTransaction(
                                    userId: userId,
                                    amount: double.parse(amount),
                                    type: type,
                                    note: note,
                                  );
                              debugPrint('isCreated is: $isCreated');

                              if (isCreated && mounted) {
                                noteController.clear();
                                amountController.clear();
                                Navigator.of(context).pop();

                                // show snackbar to notify the user
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Transaction added'),
                                  ),
                                );
                              }
                            }
                          : null,
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // show snackbar
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       const SnackBar(
                    //         content: Text('Expense added'),
                    //       ),
                    //     );
                    //     // _submitData();
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     padding: const EdgeInsets.symmetric(
                    //       // horizontal: width * 0.35,
                    //       vertical: 4,
                    //     ),
                    //     backgroundColor: AppColors.mainColor2,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(30.0),
                    //     ),
                    //   ),
                    //   child: const FullWidthButtonWithText(text: 'Save'),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void displayPhoto(File imageFile) {
    // display thumnail of the image
    debugPrint('image file path: ${imageFile.path}');
    FileThumbnailView(
      thumbnailRequest: ThumbnailRequest(
        imageFile,
        FileType.image,
      ),
    );

    setState(() {
      _imageFile = imageFile;
      debugPrint('show Picture');
    });
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

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbarTest(
      BuildContext context, Category category) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Selected category: ${category.name}'),
      duration: const Duration(seconds: 1),
      action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Undo'),
                    content: const Text('Are you sure you want to undo?'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            ref.read(selectedCategoryProvider.notifier).state =
                                category;
                          },
                          child: const Text('Undo'))
                    ],
                  );
                });
          }),
    ));
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
              // onSubmitted: (_) => _submitData(),
            ),
          ),
        ),
      ],
    );
  }
}
