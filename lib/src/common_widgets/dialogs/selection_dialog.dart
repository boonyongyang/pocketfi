import 'package:pocketfi/src/common_widgets/dialogs/alert_dialog_model.dart';
import 'package:pocketfi/src/constants/strings.dart';

class SelectionDialog extends AlertDialogModel<bool> {
  const SelectionDialog({
    required super.title,
  }) : super(
          message: 'Select an option to scan receipt',
          buttons: const {
            Strings.gallery: false,
            Strings.camera: true,
          },
        );
}
