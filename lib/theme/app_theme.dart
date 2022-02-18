import 'package:flutter/material.dart';
import 'package:catch_app/theme/app_colors.dart';
import 'package:catch_app/theme/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme{
  AppTheme._();

  static final TextTheme _regularTextTheme = TextTheme(
    headline1: AppTextStyle.headline1,
    headline2: AppTextStyle.headline2,
    headline3: AppTextStyle.headline3,
    headline4: AppTextStyle.headline4,
    headline5: AppTextStyle.headline5,
    headline6: AppTextStyle.headline6,
    subtitle1: AppTextStyle.subtitle1,
    subtitle2: AppTextStyle.subtitle2,
    bodyText1: AppTextStyle.bodyText1,
    bodyText2: AppTextStyle.bodyText2,
    button: AppTextStyle.button,
  );

  static ColorScheme _colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      onPrimary: AppColors.onPrimary,
      onSurface: AppColors.onSurface,
  );

  // static  IconThemeData _customIconTheme(IconThemeData original) {
  //   secondary: original.copyWith(color: AppColors.secondary);
  // }

  static final ThemeData regularTheme = ThemeData(
    colorScheme: _colorScheme,
    textTheme: _regularTextTheme,
    //iconTheme: _customIconTheme,

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(Size(160.w,160.h)),
        backgroundColor: MaterialStateProperty.resolveWith((states){
          AppColors.onPrimary;
        }),
        textStyle: MaterialStateProperty.all(
          AppTextStyle.button,
        ),
        foregroundColor: MaterialStateProperty.all(
            AppColors.onPrimary
        ),
        side: MaterialStateProperty.all(
          BorderSide(
            color: (AppColors.secondary[900])!,
            width: 1,
          ),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith((states){
          if(states.contains(MaterialState.disabled)){
            return AppColors.onPrimary;
          }
          return AppColors.secondary;
      }),
        textStyle: MaterialStateProperty.all(
          AppTextStyle.bodyText1,
        ),
      ),
    ),

    // outlinedButtonTheme: OutlinedButtonThemeData(
    //     style: ButtonStyle(
    //         foregroundColor: MaterialStateProperty.all(AppColors.primary[400]),
    //       textStyle: MaterialStateProperty.all(
    //           AppTextStyle.body1
    //       ),
    //       minimumSize: MaterialStateProperty.all(Size(400,120)),
    //       side: MaterialStateProperty.all(BorderSide(color: AppColors.primary)),
    //     ),
    // ),


  );

  // IconThemeData _customIconTheme(IconThemeData original) {
  //   return original.copyWith(color: AppColors.secondary);
  // }

}