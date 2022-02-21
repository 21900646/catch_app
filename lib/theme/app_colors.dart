import 'package:flutter/material.dart';

class AppColors{
  //static const Color positive = Color(0xff4E99F2);
  //static const Color negative = Color(0xffE95A5A);
  //static const Color black = Color(0xff000000);
  static const Color onPrimary = Color(0xffFFFFFF);
  static const Color onPrimary2 = Color(0xff999999);

  static const MaterialColor primary = MaterialColor(0xff2c63bb, {
    50: Color(0xffe4f2fd),
    100: Color(0xffbdddfa),
    200: Color(0xff94c9fc),
    300: Color(0xff6bb3f3),
    400: Color(0xff4fa3f1),
    500: Color(0xff3a94ee),
    600: Color(0xff3686e0),
    700: Color(0xff3174cd),
    800: Color(0xff2c63bb),
    900: Color(0xff24459b),
  });

  //onpressed가 null일때 색상
  static MaterialColor onSurface = MaterialColor(0xffFFFFFF, {
    38: Color(0xffFFFFFF).withOpacity(0.38),
    60: Color(0xffFFFFFF).withOpacity(0.60),
    87: Color(0xffFFFFFF).withOpacity(0.87),
    // 50: Color(0xffe4f2fd),
    // 100: Color(0xffbdddfa),
    // 200: Color(0xff94c9fc),
    // 300: Color(0xff6bb3f3),
    // 400: Color(0xff4fa3f1),
    // 500: Color(0xff3a94ee),
    // 600: Color(0xff3686e0),
    // 700: Color(0xff3174cd),
    // 800: Color(0xff2c63bb),
    // 900: Color(0xff24459b),
  });
  static const MaterialColor secondary = MaterialColor(0xff352727, {
    50: Color(0xffEBEBEB),
    100: Color(0xffCDCDCD),
    200: Color(0xffB1ABAA),
    300: Color(0xff978885),
    400: Color(0xff846D6A),
    500: Color(0xff71544F),
    600: Color(0xff644B48),
    700: Color(0xff543F3D),
    800: Color(0xff453433),
    900: Color(0xff352727),
  });
}