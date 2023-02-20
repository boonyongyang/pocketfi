import 'dart:io';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/category/models/category.dart';
import 'package:pocketfi/state/category/notifiers/category_state_notifier.dart';
import 'package:pocketfi/state/category/providers/category_provider.dart';
import 'package:pocketfi/state/image_upload/helpers/image_picker_helper.dart';
import 'package:pocketfi/state/image_upload/models/file_type.dart';
import 'package:pocketfi/state/image_upload/models/thumbnail_request.dart';
import 'package:pocketfi/state/tabs/timeline/posts/post_settings/providers/post_setting_provider.dart';
import 'package:pocketfi/state/tabs/timeline/transaction/models/tag.dart';
import 'package:pocketfi/views/components/file_thumbnail_view.dart';
import 'package:pocketfi/views/constants/app_colors.dart';
import 'package:pocketfi/views/tabs/timeline/transactions/add_new_transactions/transaction_date_picker.dart';

import 'package:pocketfi/views/tabs/timeline/transactions/add_new_transactions/transaction_switcher.dart';
import 'dart:math' as math;

import 'package:image/image.dart' as img;
import 'package:pocketfi/views/tabs/timeline/transactions/add_new_transactions/zoomable_image.dart';

class AddNewTransaction extends StatefulHookConsumerWidget {
  // final File fileToPost;
  // final FileType fileType;
  const AddNewTransaction({
    // this.fileToPost,
    // this.fileType,
    super.key,
  });

  @override
  AddNewTransactionState createState() => AddNewTransactionState();
}

class AddNewTransactionState extends ConsumerState<AddNewTransaction> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  File? _imageFile;
  bool _isImageZoomed = false;

  // create tags
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

  // selected tags
  List<TagChip> selectedTags = [];

  String _selectedRecurrence = 'Never';
  String _selectedWallet = 'Personal';

  void _submitData() {
    final enteredAmount = double.parse(_amountController.text);
    final enteredNote = _noteController.text;

    if (enteredAmount <= 0 || enteredNote.isEmpty) {
      return;
    }

    // Your code to handle adding the expense to the data source goes here
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;

    final categories = ref.watch(expenseCategoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // elevation: 0,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'New Transaction',
          style: TextStyle(
            color: AppSwatches.mainColor1,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          // color: Colors.transparent,
          padding: EdgeInsets.only(
            top: 50,
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Transform.scale(
                    scale: 0.83, child: const TransactionSwitcher()),
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
                    hintText: '0.0',
                  ),
                  controller: _amountController,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppSwatches.red,
                  ),
                ),
              ),
              const Text('MYR',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppSwatches.mainColor1,
                  )),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    DropdownButton<Category>(
                      underline: const SizedBox(),
                      value: selectedCategory,
                      items: categories
                          .map((category) => DropdownMenuItem<Category>(
                                value: category,
                                onTap: () =>
                                    showSnackbarTest(context, category),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: category.color,
                                      child: category.icon,
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(category.name),
                                  ],
                                ),
                              ))
                          .toList(),
                      onChanged: (Category? category) {
                        ref.read(selectedCategoryProvider.notifier).state =
                            category!;
                      },
                    ),
                    const Spacer(),
                    const Icon(Icons.wallet, color: AppSwatches.mainColor1),
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
                    // TextField(
                    //   decoration: const InputDecoration(labelText: 'Amount'),
                    //   controller: _amountController,
                    //   keyboardType: const TextInputType.numberWithOptions(
                    //     decimal: true,
                    //   ),
                    //   onSubmitted: (_) => _submitData(),
                    // ),
                    const TransactionDatePicker(),
                    WriteOptionalNote(noteController: _noteController),
                    Row(
                      children: [
                        const Icon(Icons.photo_camera_outlined,
                            color: AppSwatches.mainColor1),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: () async {
                              // pick a image first
                              final imageFile = await ImagePickerHelper
                                  .pickImageFromGallery();
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

                              // display thumnail of the image
                              displayPhoto(imageFile);
                            },
                            child: const Text(
                              'add a photo',
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_imageFile != null)
                      // FileThumbnailView(
                      //   thumbnailRequest: ThumbnailRequest(
                      //     _imageFile!,
                      //     FileType.image,
                      //   ),
                      // ),

                      Stack(
                        children: [
                          // existing content goes here
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.7,
                                    child: ZoomableImage(
                                      imagePath: _imageFile!.path,
                                    ),
                                  );
                                },
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
                        ],
                      ),
                    // Hero(
                    //   tag: 'imageHero',
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       // Navigate back to the previous screen
                    //       Navigator.pop(context);
                    //     },
                    //     child: Image.file(_imageFile!),
                    //   ),
                    // ),
                    const SizedBox(height: 8.0),
                    // const Text(
                    //   'Tags',
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.bold,
                    //     color: AppSwatches.mainColor1,
                    //   ),
                    // ),
                    Row(
                      children: [
                        const Icon(
                          Icons.catching_pokemon_sharp,
                          color: AppSwatches.mainColor1,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            // color: Colors.grey,
                            child: Wrap(
                              direction: Axis.horizontal,
                              spacing: 8.0,
                              // runSpacing: 0.0,
                              children: [
                                for (final tag in tags)
                                  FilterChip(
                                    showCheckmark: false,
                                    selectedColor: AppSwatches.mainColor2,
                                    label: Text(tag.label),
                                    selected: selectedTags.contains(tag),
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          selectedTags.add(tag);
                                        } else {
                                          selectedTags.remove(tag);
                                        }
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    selectReccurence(),
                    ElevatedButton(
                      onPressed: () {
                        // show snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Expense added'),
                          ),
                        );
                        _submitData();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          // horizontal: width * 0.35,
                          vertical: 4,
                        ),
                        backgroundColor: AppSwatches.mainColor2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Save',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
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

  void displayPhoto(File imageFile) {
    // display thumnail of the image
    debugPrint('image file path: ${imageFile.path}');
    // final thumbnailRequest = ThumbnailRequest(
    //   imageFile,
    //   FileType.image,
    // );

    // FileThumbnailView(
    //   thumbnailRequest: thumbnailRequest,
    // );
    Hero(
      tag: 'imageHero',
      child: FileThumbnailView(
        thumbnailRequest: ThumbnailRequest(
          imageFile,
          FileType.image,
        ),
      ),
    );

    final cropImageFile = _cropAndShrinkImage(imageFile, 150);

    // setState to display the thumbnail
    setState(() {
      _imageFile = cropImageFile;
      debugPrint('show Picture');
    });
  }

  File _cropAndShrinkImage(File imageFile, int maxWidth) {
    // Load the image from the file
    final rawImage = img.decodeImage(imageFile.readAsBytesSync());

    // Calculate the aspect ratio of the image
    final double aspectRatio = rawImage!.width / rawImage.height;

    // Calculate the new height of the image
    final int newHeight = (maxWidth / aspectRatio).round();

    // Calculate the amount to crop from the top and bottom of the image
    final int cropAmount = math.max(0, rawImage.height - newHeight) ~/ 2;

// Crop the image
    final croppedImage = img.copyCrop(
      rawImage,
      x: 0,
      y: cropAmount,
      width: rawImage.width,
      height: rawImage.height - (cropAmount * 2),
    );

    // Resize the image to the desired width
    final resizedImage = img.copyResize(croppedImage, width: maxWidth);

    // Convert the image to a file
    final newImageFile = File('${imageFile.path}_cropped.jpg')
      ..writeAsBytesSync(img.encodeJpg(resizedImage, quality: 85));

    return newImageFile;
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
            // show alert dialog
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
        const Icon(Icons.note_add_outlined, color: AppSwatches.mainColor1),
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
