import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pocketfi/views/constants/strings.dart';

import '../components/constants/app_colors.dart';

class FacebookButton extends StatelessWidget {
  const FacebookButton({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   return ElevatedButton(
  //     onPressed: () {},
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         FaIcon(
  //           FontAwesomeIcons.facebook,
  //           color: AppColors.facebookColor,
  //         ),
  //         const SizedBox(width: 10.0),
  //         const Text(
  //           Strings.facebook,
  //           style: TextStyle(
  //             color: Colors.white,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.facebook,
            color: AppColors.facebookColor,
          ),
          const SizedBox(width: 10.0),
          const Text(Strings.facebook),
        ],
      ),
    );
  }
}
