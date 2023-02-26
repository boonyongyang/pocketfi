import 'package:flutter/material.dart';
import 'package:pocketfi/src/common_widgets/rich_text/base_text.dart';
import 'package:pocketfi/src/common_widgets/rich_text/rich_text_widget.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:url_launcher/url_launcher.dart';

// no need constructor because it will know what to show
class LoginViewSignupLinks extends StatelessWidget {
  const LoginViewSignupLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return RichTextWidget(
      styleForAll: Theme.of(context).textTheme.subtitle1?.copyWith(
            height: 1.5,
          ),
      texts: [
        BaseText.plain(
          text: Strings.dontHaveAnAccount,
        ),
        BaseText.plain(
          text: Strings.signUpOn,
        ),
        // BaseText.plain(
        //   text: Strings.orCreateAnAccountOn,
        // ),
        BaseText.link(
          text: Strings.google,
          onTapped: () {
            launchUrl(Uri.parse(Strings.googleSignupUrl));
          },
        ),
      ],
    );
  }
}
