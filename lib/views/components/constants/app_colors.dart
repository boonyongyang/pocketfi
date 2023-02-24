import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart' show Colors;
import 'package:pocketfi/extensions/string/as_html_color_to_color.dart';

@immutable
class AppColors {
  static final loginButtonColor = '#0F3D66'.htmlColorToColor();
  static const loginButtonTextColor = Colors.white;
  static final googleColor = '#ffffff'.htmlColorToColor();
  // static final googleColor = '#4285F4'.htmlColorToColor();
  static final facebookColor = '#ffffff'.htmlColorToColor();

  const AppColors._();
}
