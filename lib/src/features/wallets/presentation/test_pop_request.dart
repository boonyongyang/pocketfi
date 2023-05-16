import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/src/common_widgets/dialogs/alert_dialog_model.dart';

@immutable
class RequestDialog extends AlertDialogModel<bool> {
  const RequestDialog({
    required String walletName,
    required String inviterName,
    String? inviterEmail,
  }) : super(
          title: 'Accept Request?',
          message:
              'Do you want to accept $walletName invited by $inviterName ($inviterEmail)?',
          buttons: const {
            'No': false,
            'Yes': true,
          },
        );
}
