import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/file_thumbnail_view.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/timeline/posts/post_settings/application/post_setting_provider.dart';
import 'package:pocketfi/src/features/timeline/posts/post_settings/domain/post_setting.dart';
import 'package:pocketfi/src/features/timeline/transactions/image_upload/application/image_uploader_provider.dart';
import 'package:pocketfi/src/features/timeline/transactions/image_upload/domain/file_type.dart';
import 'package:pocketfi/src/features/timeline/transactions/image_upload/domain/thumbnail_request.dart';

// !! TO BE REMOVED
class CreateNewPostView extends StatefulHookConsumerWidget {
  final File fileToPost;
  final FileType fileType;
  const CreateNewPostView({
    required this.fileToPost,
    required this.fileType,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateNewPostViewState();
}

class _CreateNewPostViewState extends ConsumerState<CreateNewPostView> {
  @override
  Widget build(BuildContext context) {
    final thumbnailRequest = ThumbnailRequest(
      widget.fileToPost,
      widget.fileType,
    );
    final postSettings = ref.watch(postSettingProvider);
    final postMessageController = useTextEditingController();
    final postAmountController = useTextEditingController();
    final isPostButtonEnabled = useState(false);
    useEffect(
      () {
        // this is a listener that will be called when the text changes
        void listener() {
          isPostButtonEnabled.value = postAmountController.text.isNotEmpty;
        }

        // add the listener
        // this will be called when the text changes
        // postMessageController.addListener(listener);
        postAmountController.addListener(listener);

        // return a function that will be called when the widget is disposed
        // precautionary measure, so that the listener is removed
        return () {
          // postMessageController.removeListener(listener);
          postAmountController.removeListener(listener);
        };
      },
      // keys that will be used to determine if the useEffect should be called
      // if the keys are the same, the useEffect will not be called
      [
        // postMessageController,
        postAmountController,
      ],
    );

    // if want to set on or off setting, use ref.read()
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.createNewPost),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            // if the post button is enabled, then the onPressed will be called
            onPressed: isPostButtonEnabled.value
                ? () async {
                    final userId = ref.read(
                      userIdProvider,
                    );
                    if (userId == null) {
                      return;
                    }
                    final message = postMessageController.text;
                    final amount = postAmountController.text;
                    // hook the UI to the imageUploadProvider for uploading the post
                    // hooking the UI to the provider will cause the UI to rebuild
                    final isUploaded =
                        await ref.read(imageUploadProvider.notifier).upload(
                              file: widget.fileToPost,
                              fileType: widget.fileType,
                              message: message,
                              // amount: amount.isEmpty ? 0.0 : double.parse(amount),
                              amount: double.parse(amount),
                              postSettings: postSettings,
                              userId: userId,
                            );
                    if (isUploaded && mounted) {
                      // if the post is uploaded, then pop the screen
                      Navigator.of(context).pop();
                    }
                  }
                // if the post button is disabled, then the onPressed will be null
                : null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FileThumbnailView(
              thumbnailRequest: thumbnailRequest,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: Strings.pleaseWriteYourMessageHere,
                ),
                autofocus: true,
                maxLines: null,
                // places the text in the controller
                controller: postMessageController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Amount',
                ),
                keyboardType: const TextInputType.numberWithOptions(),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(
                    r'^\d+(?:\.\d{0,2})?$',
                    // r'^(?!0(?:.0{1,2})?)\d+(?:.\d{1,2})?$',
                  )),
                ],
                autofocus: true,
                maxLines: null,
                // places the text in the controller
                controller: postAmountController,
              ),
            ),
            // map the post settings to a list of list tiles
            ...PostSetting.values.map(
              (postSetting) => ListTile(
                title: Text(postSetting.title),
                subtitle: Text(postSetting.description),
                trailing: Switch(
                  // default switch is false
                  value: postSettings[postSetting] ?? false,
                  // when the switch is toggled, set the setting(update)
                  onChanged: (isOn) {
                    ref.read(postSettingProvider.notifier).setSetting(
                          postSetting,
                          isOn,
                        );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
