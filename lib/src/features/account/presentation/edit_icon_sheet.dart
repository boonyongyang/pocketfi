import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/category/application/category_services.dart';

class EditAccountIconSheet extends StatefulHookConsumerWidget {
  const EditAccountIconSheet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditAccountIconSheetState();
}

class _EditAccountIconSheetState extends ConsumerState<EditAccountIconSheet> {
  @override
  Widget build(BuildContext context) {
    final colorList = ref.watch(categoryColorListProvider);
    final selectedColor = ref.watch(selectedCategoryColorProvider);
    final iconList = ref.watch(categoryIconListProvider);
    final selectedIcon = ref.watch(selectedCategoryIconProvider);

    final isSaveButtonEnabled = useState(false);

    debugPrint('${isSaveButtonEnabled.value}');
    debugPrint('selectedColor: $selectedColor');
    debugPrint('selectedIcon: $selectedIcon');

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.80,
      child: Container(
        color: AppColors.transparent,
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          runSpacing: 20,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    resetCategoryComponentsState(ref);
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                ),
                const Text(
                  'Change Account Icon',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(width: 40.0),
              ],
            ),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: selectedColor,
                child: Icon(selectedIcon, color: AppColors.white, size: 50),
              ),
            ),
            const SizedBox(height: 50.0),
            Row(
              children: [
                const Text("Color"),
                const SizedBox(width: 16.0),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        for (var i = 0; i < colorList.length; i++)
                          GestureDetector(
                            onTap: () {
                              ref
                                  .read(selectedCategoryColorProvider.notifier)
                                  .state = colorList[i];

                              debugPrint('$selectedColor');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: colorList[i],
                                border: Border.all(
                                  color: selectedColor == colorList[i]
                                      ? AppColors.mainColor1
                                      : Colors.grey,
                                  width: 2.0,
                                ),
                              ),
                              width: 35.0,
                              height: 35.0,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Text("Icon"),
                const SizedBox(width: 16.0),
                Expanded(
                  // grid view of 5 columns
                  child: GridView.count(
                    crossAxisCount: 5,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    shrinkWrap: true,
                    children: [
                      // loop through a list of icons and display them
                      for (var i = 0; i < iconList.length; i++)
                        // on tap change the selected icon
                        GestureDetector(
                          onTap: () {
                            ref
                                .read(selectedCategoryIconProvider.notifier)
                                .state = iconList[i];
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                              border: Border.all(
                                color: selectedIcon == iconList[i]
                                    ? AppColors.transparent
                                    : Colors.grey,
                                width: 1.0,
                              ),
                              color: selectedIcon == iconList[i]
                                  ? Colors.grey
                                  : AppColors.transparent,
                            ),
                            width: 35.0,
                            height: 35.0,
                            child: Icon(iconList[i],
                                color: selectedIcon == iconList[i]
                                    ? AppColors.white
                                    : Colors.black),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            FullWidthButtonWithText(
              onPressed: isSaveButtonEnabled.value
                  ? () async {
                      Fluttertoast.showToast(
                        msg: "Category added!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.white,
                        textColor: AppColors.mainColor1,
                        fontSize: 16.0,
                      );
                      Navigator.of(context).pop();
                    }
                  : null,
              text: Strings.save,
              backgroundColor: AppColors.mainColor2,
            ),
          ],
        ),
      ),
    );
  }
}
