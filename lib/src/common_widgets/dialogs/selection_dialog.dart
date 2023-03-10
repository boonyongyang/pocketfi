// selection dialog box which is used to select either to scan receipt using camera or to upload receipt from gallery

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

// class SelectionDialog extends AlertDialogModel<bool> {
//   const SelectionDialog({
//     required super.title,
//     required super.message,
//     required super.buttons,
//   });

//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       child: SizedBox(
//         height: 200.0,
//         width: 300.0,
//         child: Column(
//           children: <Widget>[
//             const SizedBox(
//               height: 20.0,
//             ),
//             const Text(
//               'Scan Receipt From:',
//               style: TextStyle(
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(
//               height: 20.0,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 ElevatedButton(
//                   onPressed: () {},
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all<Color>(
//                       AppColors.mainColor2,
//                     ),
//                   ),
//                   child: const Text(
//                     'Camera',
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {},
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all<Color>(
//                       AppColors.mainColor2,
//                     ),
//                   ),
//                   child: const Text(
//                     'Gallery',
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
