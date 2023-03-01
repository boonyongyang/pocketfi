import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart';
import 'package:pocketfi/src/common_widgets/dialogs/alert_dialog_model.dart';
import 'package:pocketfi/src/constants/strings.dart';

@immutable
class AlreadyExistDialog extends AlertDialogModel<bool> {
  const AlreadyExistDialog({
    required String itemName,
  }) : super(
          title: 'Alert',
          message: '$itemName already exist. Please try with different name.',
          buttons: const {
            // Strings.cancel: false,
            'Okay': true,
          },
        );
}
