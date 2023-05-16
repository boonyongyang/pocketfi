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
    final tags = ref.watch(userTagsNotifier);
    return Column(
      children: [
        Row(
          children: [
            if (tags.isNotEmpty)
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
