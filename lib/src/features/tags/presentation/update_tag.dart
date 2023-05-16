import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/common_widgets/dialogs/alert_dialog_model.dart';
import 'package:pocketfi/src/common_widgets/dialogs/delete_dialog.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/category/application/category_services.dart';
import 'package:pocketfi/src/features/tags/application/tag_services.dart';

class UpdateTag extends StatefulHookConsumerWidget {
  const UpdateTag({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdateTagState();
}

class _UpdateTagState extends ConsumerState<UpdateTag> {
  @override
  Widget build(BuildContext context) {
    final selectedTag = ref.watch(selectedTagProvider);
    final nameController = useTextEditingController(text: selectedTag?.name);
    final isSaveButtonEnabled = useState(false);
    useEffect(
      () {
        void listener() =>
            isSaveButtonEnabled.value = nameController.text.isNotEmpty;

        nameController.addListener(listener);
        return () => nameController.removeListener(listener);
      },
      [nameController],
    );
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
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
                  'Edit Tag',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_rounded,
                    color: AppColors.red,
                  ),
                  onPressed: () async {
                    final isConfirmDelete = await const DeleteDialog(
                      titleOfObjectToDelete: Strings.transaction,
                    ).present(context);

                    if (isConfirmDelete == null) return;

                    if (isConfirmDelete) {
                      await ref.read(tagProvider.notifier).deleteTag(
                            name: selectedTag!.name,
                            userId: ref.read(userIdProvider)!,
                          );
                      if (mounted) {
                        Navigator.of(context).maybePop();
                      }
                    }
                  },
                ),
              ],
            ),
            Row(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 250),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: TextField(
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Tag name',
                      ),
                      controller: nameController,
                    ),
                  ),
                ),
              ],
            ),
            FullWidthButtonWithText(
              onPressed: isSaveButtonEnabled.value
                  ? () async {
                      final userId = ref.watch(userIdProvider);
                      // check if tag name already exists

                      // create tag
                      final isCreated =
                          await ref.read(tagProvider.notifier).updateTag(
                                originalName: selectedTag!.name,
                                newName: nameController.text,
                                userId: userId!,
                              );
                      if (isCreated && mounted) {
                        Fluttertoast.showToast(
                          msg: "Tag updated!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Colors.white,
                          textColor: AppColors.mainColor1,
                          fontSize: 16.0,
                        );
                        Navigator.of(context).pop();
                      }
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
