// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:pocketfi/src/features/authentication/application/is_logged_in_provider.dart';

// class TestPopRequest extends ConsumerWidget {
//   const TestPopRequest({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     Future.delayed(Duration.zero, () => _showDialog(context));
//     final isLogged = ref.watch(isLoggedInProvider);

//     // return isLogged ? const Placeholder() : const Placeholder();
//     return Container(
//       child: Text(isLogged.toString()),
//     );

//     // return const Placeholder();
//   }

//   void _showDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('AlertDialog Title'),
//           content: const Text('AlertDialog description'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

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
