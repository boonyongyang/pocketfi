import 'package:flutter/material.dart';
import 'package:pocketfi/src/constants/material_color.dart';
import 'package:pocketfi/src/utils/extensions/string/as_html_color_to_color.dart';

@immutable
class AppColors {
  static const mainColor1 = Color(0xFF0F3D66); // Dark blue
  static const mainColor2 = Color(0xFFF8B319); // Dark Yellow
  static const subColor1 = Color(0xFF51779E); // Light Blue
  static const subColor2 = Color(0xFFFCD46A); // Light Yellow
  static const green = Color(0xFF32B04A); // Green
  static const red = Color(0xFFF1592A); // Red
  static const backgroundColor = Color(0xFFF9F9F9); // greyish white
  static const white = Color(0xFFFFFFFF); // white
  static const transparent = Color(0x00FFFFFF); // white

// type to Colors instead of Color
  static final mainMaterialColor1 = generateMaterialColor(mainColor1);
  static final mainMaterialColor2 = generateMaterialColor(mainColor2);

// login
  static final loginButtonColor = '#0F3D66'.htmlColorToColor();
  static const loginButtonTextColor = Colors.white;
  static final googleColor = '#ffffff'.htmlColorToColor();
  // static final facebookColor = '#ffffff'.htmlColorToColor();

  // for expenses categories
  static const shopping = Color(0xFFD471E8);
  static const foodAndDrink = Color(0xFFF2AC3C);
  static const groceries = Color(0xFFD08547);
  static const beauty = Color(0xFF7246C8);
  static const entertainment = Color(0xFFF2AC3C);
  static const healthcare = Color(0xFFD16B78);
  static const home = Color(0xFFB19964);
  static const billsAndFees = Color(0xFF78C1AD);
  static const familyAndPersonal = Color(0xFF60A5E0);
  static const travel = Color(0xFFE76D9F);
  static const other = Color(0xFF67686B);
  static const education = Color(0xFF4973A8);
  static const car = Color(0xFF60A5E0);
  static const gift = Color(0xFF53AF77);
  static const transport = Color(0xFFF5D046);
  static const work = Color(0xFF6D6E87);
  static const sportsAndHobbies = Color(0xFF7ECDC9);

  // for income categories
  static const salary = Color(0xFF53AF77);
  static const selling = Color(0xFFC3D85B);
  static const extraIncome = Color(0xFF85C355);
  static const loan = Color(0xFFD16B78);
  static const business = Color(0xFFF2A63A);

  const AppColors._();
}
