import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:pocketfi/src/common_widgets/rich_text/base_text.dart';

import 'link_text.dart';

class RichTextWidget extends StatelessWidget {
  final Iterable<BaseText> texts;
  final TextStyle? styleForAll;

  const RichTextWidget({
    super.key,
    required this.texts,
    this.styleForAll,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: texts.map((baseText) {
          // check if base text is link text
          if (baseText is LinkText) {
            return TextSpan(
              text: baseText.text,
              style: styleForAll?.merge(baseText.style),
              // used to make the text clickable
              recognizer: TapGestureRecognizer()..onTap = baseText.onTapped,
            );
          } else {
            return TextSpan(
              text: baseText.text,
              style: styleForAll?.merge(baseText.style),
            );
          }
        }).toList(),
      ),
    );
  }
}
