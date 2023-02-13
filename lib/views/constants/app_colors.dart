import 'package:flutter/material.dart';
import 'package:pocketfi/views/constants/material_color.dart';

@immutable
class AppColorsForAll {
  static const mainColor1 = Color(0xFF0F3D66); // Dark blue
  static const mainColor2 = Color(0xFFF8B319); // Dark Yellow
  static const subColor1 = Color(0xFF51779E); // Light Blue
  static const subColor2 = Color(0xFFFCD46A); // Light Yellow
  static const green = Color(0xFF32B04A); // Green
  static const red = Color(0xFFF1592A); // Red
  static const backgroundColor = Color(0xFFF9F9F9); // greyish white

// type to Colors instead of Color
  static final mainMaterialColor1 = generateMaterialColor(mainColor1);

  const AppColorsForAll._();
}
