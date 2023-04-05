import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/tags/application/tag_services.dart';

class SelectTagWidget extends ConsumerStatefulWidget {
  const SelectTagWidget({Key? key}) : super(key: key);

  @override
  SelectTagWidgetState createState() => SelectTagWidgetState();
}

class SelectTagWidgetState extends ConsumerState<SelectTagWidget> {
  @override
  Widget build(BuildContext context) {
    // final tags = ref.watch(userTagsProvider).value ?? [];
    final tags = ref.watch(userTagsNotifier);
    return Column(
      children: [
        // Text('all tags: ${tags.map((e) => e.name).join(', ')}'),
        // Text(
        //     'tags: ${tags.where((tag) => tag.isSelected).map((e) => e.name).join(', ')}'),
        // TextButton(
        //   onPressed: () {
        //     ref.read(userTagsNotifier.notifier).resetTagsState(ref);
        //   },
        //   child: const Text('Clear'),
        // ),
        Row(
          children: [
            const Icon(
              Icons.label_important_rounded,
              color: AppColors.mainColor1,
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 8.0,
                  children: tags
                      .map(
                        (tag) => InputChip(
                          label: Text(tag.name),
                          selected: tag.isSelected,
                          onSelected: (selected) {
                            final updatedTag =
                                tag.copyWith(isSelected: selected);
                            final updatedTags = tags.map((existingTag) {
                              if (existingTag.name == tag.name) {
                                return updatedTag;
                              } else {
                                return existingTag;
                              }
                            }).toList();
                            ref
                                .read(userTagsNotifier.notifier)
                                .setTags(updatedTags);
                            // ref.read(userTagsProvider).value = updatedTags;

                            Fluttertoast.showToast(
                              msg: selected
                                  ? 'Added ${tag.name}'
                                  : 'Removed ${tag.name}',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor:
                                  selected ? AppColors.mainColor1 : Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );

                            // setState(() {});

                            // final daTags =
                            //     ref.watch(chosenTagsProvider).toSet();

                            // debugPrint(
                            //     'da Tags: ${daTags.map((e) => e.name).join(', ')}');
                          },
                          selectedColor: AppColors.mainColor2,
                          showCheckmark: false,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// class SelectTagWidget extends ConsumerWidget {
//   const SelectTagWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final tags = ref.watch(userTagsProvider).value ?? [];
//     final selectedTags = ref.watch(chosenTagsProvider).toSet();

//     return Row(
//       children: [
//         const Icon(
//           Icons.label_important_rounded,
//           color: AppColors.mainColor1,
//         ),
//         const SizedBox(width: 14.0),
//         Expanded(
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Wrap(
//               direction: Axis.horizontal,
//               spacing: 8.0,
//               children: tags
//                   .map(
//                     (tag) => InputChip(
//                       label: Text(tag.name),
//                       selected: selectedTags.contains(tag),
//                       onSelected: (selected) {
//                         if (selected) {
//                           ref.read(chosenTagsProvider).add(tag);
//                           Fluttertoast.showToast(
//                             msg: 'Added ${tag.name}',
//                             toastLength: Toast.LENGTH_SHORT,
//                             gravity: ToastGravity.BOTTOM,
//                             timeInSecForIosWeb: 1,
//                             backgroundColor: Colors.green,
//                             textColor: Colors.white,
//                             fontSize: 16.0,
//                           );

//                           debugPrint(
//                               'selectedTags: ${selectedTags.map((e) => e.name).join(', ')}');
//                           debugPrint(
//                               'number of selected tags: ${selectedTags.length}');
//                         } else {
//                           ref.read(chosenTagsProvider).remove(tag);
//                         }
//                         // update the state of the provider
//                         ref.refresh(chosenTagsProvider);
//                       },
//                       selectedColor: AppColors.mainColor2,
//                       showCheckmark: false,
//                     ),
//                   )
//                   .toList(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }


// class SelectTagWidget extends ConsumerWidget {
//   const SelectTagWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final tags = ref.watch(userTagsProvider).value ?? [];
//     List<Tag> selectedTags = [];

//     return Row(
//       children: [
//         const Icon(
//           Icons.label_important_rounded,
//           color: AppColors.mainColor1,
//         ),
//         const SizedBox(width: 14.0),
//         Expanded(
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Wrap(
//               direction: Axis.horizontal,
//               spacing: 8.0,
//               children: tags
//                   .map(
//                     (tag) => InputChip(
//                       label: Text(tag.name),
//                       selected: selectedTags.contains(tag),
//                       onSelected: (selected) {
//                         if (selected) {
//                           selectedTags.add(tag);
//                           Fluttertoast.showToast(
//                             msg: 'Added ${tag.name}',
//                             toastLength: Toast.LENGTH_SHORT,
//                             gravity: ToastGravity.BOTTOM,
//                             timeInSecForIosWeb: 1,
//                             backgroundColor: Colors.green,
//                             textColor: Colors.white,
//                             fontSize: 16.0,
//                           );
//                           debugPrint('selectedTags: ${selectedTags.length}');
//                         } else {
//                           selectedTags.remove(tag);
//                         }
//                       },
//                       selectedColor: AppColors.mainColor2,
//                       showCheckmark: false,
//                     ),
//                   )
//                   .toList(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
