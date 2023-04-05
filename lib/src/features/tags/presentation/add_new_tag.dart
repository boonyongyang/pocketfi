import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/category/application/category_services.dart';
import 'package:pocketfi/src/features/tags/application/tag_services.dart';
import 'package:pocketfi/src/features/transactions/application/transaction_services.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';

class AddNewTag extends StatefulHookConsumerWidget {
  const AddNewTag({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddNewTagState();
}

class _AddNewTagState extends ConsumerState<AddNewTag> {
  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
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

    debugPrint('${isSaveButtonEnabled.value}');

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
                  'Create new Tag',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(width: 40.0),
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
                          await ref.read(tagProvider.notifier).addNewTag(
                                name: nameController.text,
                                userId: userId!,
                              );
                      if (isCreated && mounted) {
                        Fluttertoast.showToast(
                          msg: "Tag created!",
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
