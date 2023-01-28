// convert hex color to Color
import 'package:flutter/material.dart';
import 'package:pocketfi/extensions/string/remove_all.dart';

extension AsHtmlColorToColor on String {
  Color htmlColorToColor() => Color(
        int.parse(
          removeAll(['0x', '#']).padLeft(8, 'ff'),
          radix: 16,
        ),
        // 0xff0093 conver to 8 digits
      );
}
