import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart';
import 'package:pocketfi/src/common_widgets/dialogs/alert_dialog_model.dart';
import 'package:pocketfi/src/constants/strings.dart';

@immutable
class DeleteDialog extends AlertDialogModel<bool> {
  const DeleteDialog({
    required String titleOfObjectToDelete,
  }) : super(
          title: '${Strings.delete} $titleOfObjectToDelete?',
          message:
              '${Strings.areYouSureYouWantToDeleteThis} $titleOfObjectToDelete?',
          buttons: const {
            Strings.cancel: false,
            Strings.delete: true,
          },
        );
}
